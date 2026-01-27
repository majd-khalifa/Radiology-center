from django.db import models
from django.contrib.auth.models import User

class Device(models.Model):
    name = models.CharField(max_length=100, verbose_name="اسم الجهاز")
    specialty = models.CharField(max_length=100, blank=True, verbose_name="التخصص")
    description = models.TextField(blank=True, verbose_name="وصف الجهاز")
    image = models.ImageField(upload_to='devices/', null=True, blank=True, verbose_name="صورة الجهاز")
    rating = models.DecimalField(max_digits=2, decimal_places=1, default=5.0, verbose_name="التقييم")
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):  # تم تصحيحها بإضافة الـ underscores
        return self.name

    class Meta:
        verbose_name = "Device"
        verbose_name_plural = "Devices"
        ordering = ['-created_at']

class Appointment(models.Model):
    device = models.ForeignKey(Device, on_delete=models.CASCADE, related_name='appointments')
    patient = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, blank=True)
    date = models.DateField()
    time = models.TimeField()
    is_available = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ('device', 'date', 'time')
        ordering = ['date', 'time']

    def __str__(self):  # تم تصحيحها
        return f"{self.device.name} - {self.date} {self.time}"
    
class Holiday(models.Model):
    date = models.DateField(unique=True, verbose_name="تاريخ العطلة")
    reason = models.CharField(max_length=200, blank=True, verbose_name="السبب")

    def __str__(self):  # تم تصحيحها
        return f"عطلة بتاريخ {self.date}"

    class Meta:
        verbose_name = "يوم عطلة"
        verbose_name_plural = "أيام العطل"
        ordering = ['date']