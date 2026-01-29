from rest_framework import serializers
from django.contrib.auth.models import User
from .models import PatientProfile


class PatientProfileSerializer(serializers.ModelSerializer):
    """
    Serializer خاص ببروفايل المريض
    يدعم GET و PATCH ومتوافق مع الموديل الحالي
    """

    class Meta:
        model = PatientProfile
        fields = [
            'full_name',
            'birth_day',
            'birth_month',
            'birth_year',
            'gender',
            'description',
            'contact_number',
            'patient_email',
            'location',
            'profile_image',
        ]


class UserSerializer(serializers.ModelSerializer):
    # تغيير اسم الحقل ليظهر كـ name بدلاً من username
    name = serializers.CharField(source='username')
    # إضافة حقل الـ role بناءً على صلاحيات المستخدم
    role = serializers.SerializerMethodField()

    class Meta:
        model = User
        fields = [
            'id',
            'name',
            'email',
            'role'
        ]

    def get_role(self, obj):
        # إذا كان مستخدم فائق أو موظف نعتبره admin
        if obj.is_superuser or obj.is_staff:
            return "admin"
        return "user"


class RegisterSerializer(serializers.ModelSerializer):
    """
    Serializer خاص بتسجيل المستخدم
    """

    password = serializers.CharField(
        write_only=True,
        min_length=8,
        style={'input_type': 'password'}
    )

    class Meta:
        model = User
        fields = [
            'username',   # صار مستقل
            'email',
            'password',
            'first_name'
        ]

    def validate_email(self, value):
        if User.objects.filter(email=value).exists():
            raise serializers.ValidationError(
                "هذا البريد الإلكتروني مستخدم بالفعل"
            )
        return value

    def create(self, validated_data):
        user = User.objects.create_user(
            username=validated_data['username'],   # صار منفصل عن الإيميل
            email=validated_data['email'],
            password=validated_data['password'],
            first_name=validated_data.get('first_name', '')
        )

        # إنشاء بروفايل تلقائي
        PatientProfile.objects.create(
            user=user,
            full_name=user.first_name
        )

        return user
