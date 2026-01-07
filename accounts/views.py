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