from django.db import models
from django.contrib.auth.models import User

class PatientProfile(models.Model):
    # خيارات الجنس (Radio Buttons في التصميم)
    GENDER_CHOICES = [
        ('Male', 'Male'),
        ('Female', 'Female'),
        ('Others', 'Others'),
    ]
    user = models.OneToOneField('auth.User', on_delete=models.CASCADE)
    full_name = models.CharField(max_length=255)
    description = models.TextField(blank=True, null=True, verbose_name="وصف المريض")
    # ... بقية الحقول (تاريخ الميلاد والجنس)
    # حقول العمر المنفصلة (Dropdowns في التصميم)
    birth_day = models.CharField(max_length=2, blank=True, null=True)
    birth_month = models.CharField(max_length=20, blank=True, null=True)
    birth_year = models.CharField(max_length=4, blank=True, null=True)
    
    gender = models.CharField(max_length=10, choices=GENDER_CHOICES, default='Male')
    contact_number = models.CharField(max_length=20, blank=True)
    
    # البريد الإلكتروني الخاص بالتواصل
    patient_email = models.EmailField(blank=True, null=True)
    
    # حقول إضافية للبروفايل العام (صورة 39)
    location = models.CharField(max_length=255, blank=True)
    profile_image = models.ImageField(upload_to='profiles/', null=True, blank=True)

    def __str__(self):
        return self.full_name if self.full_name else self.user.username