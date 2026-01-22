from rest_framework.response import Response
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny
from django.contrib.auth import authenticate
from rest_framework.authtoken.models import Token
from django.contrib.auth.models import User
from django.db import IntegrityError
from rest_framework.permissions import IsAdminUser # لضمان أن الأدمن فقط من يملك الصلاحية
from .serializers import UserSerializer
from rest_framework import viewsets
from django.contrib.auth.models import User 

@api_view(['POST'])
@permission_classes([AllowAny])
def login_view(request):
    # استقبال Email و Password فقط
    email = request.data.get('email')
    password = request.data.get('password')
    
    if not email or not password:
        return Response({"message": "Email and password are required"}, status=400)

    # محاولة توثيق المستخدم (Django يستخدم username داخلياً لذا نمرر الإيميل مكانه)
    user = authenticate(username=email, password=password)
    
    if user:
        token, _ = Token.objects.get_or_create(user=user)
        # إرجاع الـ ID والبيانات المطلوبة
        return Response({
            "data": {
                "user": {
                    "id": user.id, 
                    "name": user.first_name, # نستخدم first_name للسماح بالتكرار
                    "email": user.email,
                    "role": "user"
                },
                "token": token.key
            },
            "message": "Login successfully"
        }, status=200)
    
    return Response({"message": "Invalid email or password"}, status=401)

@api_view(['POST'])
@permission_classes([AllowAny])
def register_user(request):
    email = request.data.get('email')
    password = request.data.get('password')
    name = request.data.get('name') # الاسم الذي يمكن أن يتكرر

    if User.objects.filter(email=email).exists():
        return Response({"message": "هذا الحساب مسجل مسبقاً"}, status=400)

    try:
        # إنشاء المستخدم بجعل الإيميل هو الـ username لضمان عدم التكرار
        user = User.objects.create_user(username=email, email=email, password=password)
        user.first_name = name # تخزين الاسم القابل للتكرار هنا
        user.save()
        
        token = Token.objects.create(user=user)
        return Response({
            "data": {"id": user.id, "token": token.key},
            "message": "User created successfully"
        }, status=201)
    except Exception as e:
        return Response({"message": str(e)}, status=400)
    

class UserManagementViewSet(viewsets.ModelViewSet):
    """
    هذا الكلاس يوفر تلقائياً:
    1. GET /api/accounts/users/ -> عرض كل الحسابات
    2. GET /api/accounts/users/{id}/ -> عرض حساب معين
    3. PUT /api/accounts/users/{id}/ -> تعديل حساب
    4. DELETE /api/accounts/users/{id}/ -> حذف حساب
    """
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = [IsAdminUser] # حماية الرابط ليكون للأدمن فقط