from django.db import models
from django.contrib.auth.models import User


class Device(models.Model):
    # الـ ID يتم إنشاؤه تلقائياً بواسطة Django كـ AutoField
    name = models.CharField(max_length=100, verbose_name="اسم الجهاز")
    specialty = models.CharField(max_length=100, blank=True, verbose_name="التخصص")
    description = models.TextField(blank=True, verbose_name="وصف الجهاز") # الحقل المطلوب
    image = models.ImageField(upload_to='devices/', null=True, blank=True, verbose_name="صورة الجهاز")
    rating = models.DecimalField(max_digits=2, decimal_places=1, default=5.0, verbose_name="التقييم")

    def __str__(self):
        return self.name

    class Meta:
        verbose_name = "Device"
        verbose_name_plural = "Devices"

class Appointment(models.Model):
    device = models.ForeignKey(Device, on_delete=models.CASCADE, related_name='appointments')
    patient = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, blank=True)
    date = models.DateField()
    time = models.TimeField()
    is_available = models.BooleanField(default=True)

    class Meta:
        # منع تكرار نفس الموعد لنفس الجهاز في نفس الوقت
        unique_together = ('device', 'date', 'time')

    def __str__(self):
        return f"{self.device.name} - {self.date} {self.time}"
    
class Holiday(models.Model):
    date = models.DateField(unique=True, verbose_name="تاريخ العطلة")
    reason = models.CharField(max_length=200, blank=True, verbose_name="السبب")

    def __str__(self):
        return f"عطلة بتاريخ {self.date}"

    class Meta:
        verbose_name = "يوم عطلة"
        verbose_name_plural = "أيام العطل"
        