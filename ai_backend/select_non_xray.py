import os
import random
import shutil
from torchvision.datasets import CIFAR10
from torchvision import transforms

# عدد الصور المطلوب
NUM_IMAGES = 500

# مجلد الوجهة
DEST_DIR = "dataset/train/non_xray"
os.makedirs(DEST_DIR, exist_ok=True)

# تحميل CIFAR-10
dataset = CIFAR10(root="cifar_data", download=True, transform=transforms.ToTensor())

# اختيار عشوائي
indices = random.sample(range(len(dataset)), NUM_IMAGES)

for idx in indices:
    img, label = dataset[idx]
    img = transforms.ToPILImage()(img)
    img.save(os.path.join(DEST_DIR, f"nonxray_{idx}.png"))

print(f"✅ تم تجهيز {NUM_IMAGES} صورة non‑xray داخل {DEST_DIR}")
