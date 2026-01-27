import os
import torch
import torch.nn as nn
from torch.utils.data import DataLoader
from torchvision import datasets, transforms, models

# ============================
# 1) إعداد التحويلات (Transforms)
# ============================
transform = transforms.Compose([
    transforms.Resize((224, 224)),
    transforms.ToTensor(),
    transforms.Normalize([0.485, 0.456, 0.406],
                         [0.229, 0.224, 0.225])
])

# ============================
# 2) تحميل الداتا
# ============================
train_dir = "dataset/train"

dataset = datasets.ImageFolder(train_dir, transform=transform)
train_loader = DataLoader(dataset, batch_size=16, shuffle=True)

print("عدد الصور:", len(dataset))
print("الفئات:", dataset.classes)

# ============================
# 3) تجهيز الموديل ResNet18
# ============================
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

model = models.resnet18(weights=models.ResNet18_Weights.IMAGENET1K_V1)
model.fc = nn.Linear(model.fc.in_features, 1)  # إخراج واحد (Binary)

model = model.to(device)

# ============================
# 4) Loss + Optimizer
# ============================
criterion = nn.BCEWithLogitsLoss()
optimizer = torch.optim.Adam(model.parameters(), lr=1e-4)

# ============================
# 5) التدريب
# ============================
EPOCHS = 5

for epoch in range(EPOCHS):
    model.train()
    total_loss = 0

    for images, labels in train_loader:
        images = images.to(device)
        labels = labels.float().unsqueeze(1).to(device)  # (N,1)

        optimizer.zero_grad()

        outputs = model(images)
        loss = criterion(outputs, labels)

        loss.backward()
        optimizer.step()

        total_loss += loss.item()

    print(f"Epoch {epoch+1}/{EPOCHS} - Loss: {total_loss/len(train_loader):.4f}")

# ============================
# 6) حفظ الموديل
# ============================
torch.save(model.state_dict(), "xray_classifier_state_dict.pth")
print("✅ تم حفظ الموديل بنجاح: xray_classifier_state_dict.pth")
