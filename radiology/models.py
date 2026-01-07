from django.db import models
from django.contrib.auth.models import User

class Device(models.Model):
    name = models.CharField(max_length=100, verbose_name="اسم الجهاز")
    specialty = models.CharField(max_length=100, blank=True, verbose_name="التخصص/العيادة")
    description = models.TextField(blank=True, verbose_name="وصف الجهاز")
    image = models.ImageField(upload_to='devices/', null=True, blank=True, verbose_name="صورة الجهاز")
    rating = models.DecimalField(max_digits=3, decimal_places=1, default=5.0, verbose_name="التقييم")

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