from django.db import models
from django.contrib.auth.models import User

class Device(models.Model):
    name = models.CharField(max_length=100)
    # أضف أي حقول أخرى للجهاز هنا

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