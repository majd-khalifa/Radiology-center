from django.db import models

class Device(models.Model):
    name = models.CharField(max_length=100) # مثل: MRI 3 Tesla
    description = models.TextField()         # وصف الجهاز ومميزاته
    image = models.ImageField(upload_to='devices/') # صورة الجهاز التي ستظهر في الدائرة
    price = models.DecimalField(max_digits=10, decimal_places=2) # سعر الجلسة
    
    def __str__(self):
        return self.name

class TimeSlot(models.Model):
    device = models.ForeignKey(Device, on_delete=models.CASCADE, related_name='slots')
    start_time = models.DateTimeField() # وقت البدء
    is_available = models.BooleanField(default=True) # هل الموعد محجوز؟

    def __str__(self):
        return f"{self.device.name} - {self.start_time}"