from rest_framework import status
from rest_framework import status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from .serializers import RegisterSerializer
from rest_framework import generics
from .models import PatientProfile
from .serializers import PatientProfileSerializer
from rest_framework.permissions import IsAuthenticated

@api_view(['POST'])
@permission_classes([AllowAny])
def login_view(request):
    # 1. استخراج البيانات المطلوبة (Email + Password)
    email = request.data.get('email')
    password = request.data.get('password')
    
    # 2. التحقق من أن الحقول المطلوبة موجودة (Required)
    if not email or not password:
        return Response({
            "status": False,
            "message": "Required: Email and Password must be provided"
        }, status=400)

    # 3. محاولة توثيق المستخدم (نستخدم الـ email كـ username في نظام Django)
    user = authenticate(username=email, password=password)
    
    if user:
        # إنشاء أو جلب التوكن
        token, _ = Token.objects.get_or_create(user=user)
        
        # 4. بناء الرد النهائي ليطابق طلبك والـ ID
        return Response({
            "data": {
                "user": {
                    "id": user.id,          # الـ ID التلقائي من قاعدة البيانات
                    "name": user.username.split('@')[0], # استخراج الاسم قبل الـ @
                    "email": user.email,
                    "role": "user"
                },
                "token": token.key          # التوكن اللازم لعمل المبرمج
            },
            "message": "Login successfully" # رسالة النجاح كما بالصورة
        }, status=200)
    
    # في حال كانت البيانات خاطئة
    return Response({
        "status": False,
        "message": "Invalid email or password"
    }, status=401)

@api_view(['POST'])
@permission_classes([AllowAny]) # ضروري جداً للسماح بالتسجيل بدون Token
def register_user(request):
    serializer = RegisterSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save()
        return Response({
            "status": "success",
            "message": "تم إنشاء الحساب بنجاح!"
        }, status=status.HTTP_201_CREATED)
    
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class PatientProfileUpdateView(generics.RetrieveUpdateAPIView):
    serializer_class = PatientProfileSerializer
    permission_classes = [IsAuthenticated]

    def get_object(self):
        # جلب البروفايل الخاص بالمستخدم المسجل حالياً فقط
        profile, created = PatientProfile.objects.get_or_create(user=self.request.user)
        return profile