from rest_framework import serializers
from django.contrib.auth.models import User
from .models import PatientProfile

# 1. سيرياليزر البروفايل (يجب أن يكون في الأعلى)
class PatientProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = PatientProfile
        # هذه الحقول مطابقة تماماً لشاشة Patient Details (صورة 34) وشاشة Profile (صورة 39)
        fields = [
            'full_name', 
            'birth_day', 
            'birth_month', 
            'birth_year', 
            'gender', 
            'contact_number', 
            'patient_email', 
            'location', 
            'profile_image'
        ]

# 2. سيرياليزر المستخدم الأساسي
class UserSerializer(serializers.ModelSerializer):
    profile = PatientProfileSerializer(read_only=True)

    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'profile']

# 3. سيرياليزر التسجيل
class RegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)

    class Meta:
        model = User
        fields = ('username', 'email', 'password')

    def create(self, validated_data):
       
        # استخدام create_user هو ما يضمن تشفير الباسورد
        user = User.objects.create_user(
            username=validated_data['username'],
            email=validated_data['email'],
            password=validated_data['password']
        )
        # إنشاء بروفايل فارغ تلقائياً بمجرد التسجيل ليتم ملؤه لاحقاً في شاشة Step 1/4
        PatientProfile.objects.create(user=user)
        return user