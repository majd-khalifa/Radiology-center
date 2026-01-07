from django.contrib import admin
from .models import Device, Appointment  # تأكد من تغيير الاسم هنا

admin.site.register(Device)
admin.site.register(Appointment)