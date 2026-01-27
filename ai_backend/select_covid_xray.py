import os
import random
import shutil

# عدد الصور المطلوب من كل فئة
NUM_IMAGES = 250

# المسارات الحقيقية
COVID_SRC = "COVID-19_Radiography_Dataset/COVID/images"
NORMAL_SRC = "COVID-19_Radiography_Dataset/Normal/images"
DEST_DIR = "dataset/train/xray"

os.makedirs(DEST_DIR, exist_ok=True)

def copy_random(src, dest, num):
    files = [f for f in os.listdir(src) if f.lower().endswith((".png", ".jpg", ".jpeg"))]
    available = len(files)

    if available == 0:
        print(f"❌ لا يوجد صور في {src}")
        return

    if available < num:
        print(f"⚠️ عدد الصور أقل من المطلوب ({available} < {num}) → سيتم نسخ كل الصور")
        selected = files
    else:
        selected = random.sample(files, num)

    for f in selected:
        shutil.copy(os.path.join(src, f), dest)

    print(f"✅ تم نسخ {len(selected)} صورة من {src}")

# تنفيذ النسخ
copy_random(COVID_SRC, DEST_DIR, NUM_IMAGES)
copy_random(NORMAL_SRC, DEST_DIR, NUM_IMAGES)
