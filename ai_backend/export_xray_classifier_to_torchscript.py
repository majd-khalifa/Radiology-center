import torch
import torch.nn as nn
from torchvision import models

# ============================
# 1) تحميل الموديل
# ============================
model = models.resnet18(weights=None)
model.fc = nn.Linear(model.fc.in_features, 1)

state_dict = torch.load("xray_classifier_state_dict.pth", map_location="cpu")
model.load_state_dict(state_dict)
model.eval()

# ============================
# 2) مثال إدخال (Dummy Input)
# ============================
example = torch.randn(1, 3, 224, 224)

# ============================
# 3) تحويل إلى TorchScript
# ============================
traced = torch.jit.trace(model, example)

# ============================
# 4) حفظ الموديل
# ============================
traced.save("xray_classifier.pt")

print("✅ تم إنشاء ملف TorchScript بنجاح: xray_classifier.pt")
