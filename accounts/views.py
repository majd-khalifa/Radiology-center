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
def login_view(request):
    email = request.data.get('email')
    password = request.data.get('password')
    
    # التحقق من المستخدم
    user = authenticate(username=email, password=password)
    
    if user:
        token, _ = Token.objects.get_or_create(user=user)
        return Response({
            "status": True,
            "data": {
                "user": {
                    "id": user.id,
                    "name": user.username.split('@')[0], # استخراج الاسم من الإيميل كمثال
                    "email": user.email,
                    "role": "user"
                },
                "token": token.key
            },
            "message": "Login successfully"
        }, status=200)
    else:
        return Response({
            "status": False,
            "message": "Invalid credentials"
        }, status=401)
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