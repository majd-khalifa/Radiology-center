from django.contrib.auth.models import User
from django.contrib.auth import authenticate

from rest_framework.response import Response
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny, IsAuthenticated, IsAdminUser
from rest_framework.authtoken.models import Token
from rest_framework import status, viewsets

from .serializers import (
    UserSerializer,
    RegisterSerializer,
    PatientProfileSerializer
)
from .models import PatientProfile


# ===========================
# Login
# ===========================
@api_view(['POST'])
@permission_classes([AllowAny])
def login_view(request):
    email = request.data.get('email')
    password = request.data.get('password')

    if not email or not password:
        return Response(
            {"message": "Email and password are required"},
            status=status.HTTP_400_BAD_REQUEST
        )

    user = authenticate(
        username=email,
        password=password
    )

    if not user:
        return Response(
            {"message": "Invalid email or password"},
            status=status.HTTP_401_UNAUTHORIZED
        )

    # إعادة إنشاء التوكن
    Token.objects.filter(user=user).delete()
    token = Token.objects.create(user=user)

    return Response({
        "message": "Login successfully",
        "data": {
            "user": UserSerializer(user).data,
            "token": token.key
        }
    }, status=status.HTTP_200_OK)


# ===========================
# Register
# ===========================
@api_view(['POST'])
@permission_classes([AllowAny])
def register_user(request):
    serializer = RegisterSerializer(data=request.data)

    if serializer.is_valid():
        user = serializer.save()
        token = Token.objects.create(user=user)

        return Response({
            "message": "User created successfully",
            "data": {
                "user": UserSerializer(user).data,
                "token": token.key
            }
        }, status=status.HTTP_201_CREATED)

    return Response(
        serializer.errors,
        status=status.HTTP_400_BAD_REQUEST
    )


# ===========================
# Logout
# ===========================
@api_view(['POST'])
@permission_classes([IsAuthenticated])
def logout_view(request):
    if request.auth:
        request.auth.delete()

    return Response(
        {"message": "Logged out successfully"},
        status=status.HTTP_200_OK
    )


# ===========================
# Profile (GET / PATCH)
# ===========================
@api_view(['GET', 'PATCH'])
@permission_classes([IsAuthenticated])
def profile_view(request):
    profile, _ = PatientProfile.objects.get_or_create(
        user=request.user,
        defaults={"full_name": request.user.first_name}
    )

    if request.method == 'GET':
        serializer = PatientProfileSerializer(profile)
        return Response(serializer.data, status=status.HTTP_200_OK)

    serializer = PatientProfileSerializer(
        profile,
        data=request.data,
        partial=True
    )

    if serializer.is_valid():
        serializer.save()
        return Response({
            "message": "Profile updated successfully",
            "data": serializer.data
        }, status=status.HTTP_200_OK)

    return Response(
        serializer.errors,
        status=status.HTTP_400_BAD_REQUEST
    )


# ===========================
# Admin – User Management
# ===========================
class UserManagementViewSet(viewsets.ModelViewSet):
    """
    CRUD للمستخدمين (Admin فقط)
    """
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = [IsAdminUser]