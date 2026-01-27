from fastapi import FastAPI, File, UploadFile
from fastapi.responses import JSONResponse
from fastapi.middleware.cors import CORSMiddleware
from PIL import Image
import torch
import torchvision.transforms as transforms
import io
import os

app = FastAPI()

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ============================
# 1) تحميل كلاسيفاير X-ray
# ============================
CLASSIFIER_PATH = os.path.join("models", "xray_classifier.pt")
print("🔍 Loading X-ray classifier:", CLASSIFIER_PATH)
xray_classifier = torch.jit.load(CLASSIFIER_PATH, map_location="cpu")
xray_classifier.eval()

# ============================
# 2) تحميل موديل CheXNet
# ============================
CHEXNET_PATH = os.path.join("models", "chestxray_chexnet_optimized.pt")
print("🔥 Loading CheXNet model:", CHEXNET_PATH)
chexnet = torch.jit.load(CHEXNET_PATH, map_location="cpu")
chexnet.eval()

# ============================
# 3) Labels
# ============================
LABELS = [
    "Atelectasis", "Cardiomegaly", "Effusion", "Infiltration", "Mass", "Nodule",
    "Pneumonia", "Pneumothorax", "Consolidation", "Edema", "Emphysema", "Fibrosis",
    "Pleural Thickening", "Hernia"
]

# ============================
# 4) Preprocessing
# ============================
classifier_transform = transforms.Compose([
    transforms.Resize((224, 224)),
    transforms.ToTensor(),
    transforms.Normalize([0.485, 0.456, 0.406],
                         [0.229, 0.224, 0.225])
])

chexnet_transform = transforms.Compose([
    transforms.Resize((224, 224)),
    transforms.ToTensor(),
    transforms.Normalize(
        mean=[0.485, 0.456, 0.406],
        std=[0.229, 0.224, 0.225]
    )
])

# ============================
# 5) API Endpoint
# ============================
@app.post("/analyze-xray")
async def analyze_xray(file: UploadFile = File(...)):
    try:
        contents = await file.read()
        image = Image.open(io.BytesIO(contents)).convert("RGB")

        # -----------------------------------------
        # خطوة 1: التحقق هل الصورة فعلاً X-ray
        # -----------------------------------------
        cls_input = classifier_transform(image).unsqueeze(0)

        with torch.no_grad():
            cls_out = xray_classifier(cls_input)
            cls_prob = torch.sigmoid(cls_out)[0].item()

        print(f"🔎 X-ray probability: {cls_prob:.4f}")

        if cls_prob < 0.50:
            return JSONResponse(
                status_code=422,
                content={
                    "success": False,
                    "error": "الصورة ليست أشعة صدر (تم رفضها بواسطة الكلاسيفاير)."
                }
            )

        # -----------------------------------------
        # خطوة 2: تحليل الأمراض باستخدام CheXNet
        # -----------------------------------------
        cxr_input = chexnet_transform(image).unsqueeze(0)

        with torch.no_grad():
            outputs = chexnet(cxr_input)
            logits = outputs[0]
            probs = torch.sigmoid(logits).tolist()

        # جميع الأمراض
        raw_predictions = {
            LABELS[i]: round(probs[i] * 100, 2)
            for i in range(len(LABELS))
        }

        # فلترة الأمراض التي نسبتها > 50%
        filtered_predictions = {
            disease: score
            for disease, score in raw_predictions.items()
            if score > 50
        }

        # ترتيب النتائج
        sorted_predictions = dict(
            sorted(filtered_predictions.items(), key=lambda kv: kv[1], reverse=True)
        )

        return {
            "success": True,
            "xray_confidence": round(cls_prob * 100, 2),
            "positive_findings": sorted_predictions
        }

    except Exception as e:
        print("❌ Error:", e)
        return JSONResponse(
            status_code=500,
            content={"success": False, "error": str(e)}
        )
