**# AI Backend (FastAPI + Torch)**



هذا السيرفر مسؤول عن تحليل صور أشعة الصدر باستخدام موديلين:

\- كلاسيفاير لتحديد إذا كانت الصورة فعلاً X-ray

\- CheXNet لتحليل الأمراض داخل الصورة



**## خطوات التشغيل**



```bash

cd ai\_backend



python -m venv venv



source venv/bin/activate



###### venv\\Scripts\\activate على Windows



pip install -r requirements.txt



uvicorn main:app --reload --host 0.0.0.0 --port 8000



