from rest_framework.response import Response
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny, IsAdminUser
from rest_framework.authtoken.models import Token as AuthToken
from rest_framework import viewsets

from django.contrib.auth import authenticate
from django.contrib.auth.models import User
from django.db import IntegrityError

from .serializers import UserSerializer


from django.contrib.auth import get_user_model

User = get_user_model()

@api_view(['POST'])
@permission_classes([AllowAny])
def login_view(request):
    email = request.data.get('email')
    password = request.data.get('password')

    if not email or not password:
        return Response({"message": "Email and password are required"}, status=400)

    try:
        user = User.objects.get(email=email)
    except User.DoesNotExist:
        return Response({"message": "Invalid email or password"}, status=401)

    if not user.check_password(password):
        return Response({"message": "Invalid email or password"}, status=401)

    token, _ = AuthToken.objects.get_or_create(user=user)

    return Response({
        "data": {
            "user": {
                "id": user.id,
                "name": user.first_name,
                "email": user.email,
                "role": "admin" if user.is_superuser else "user"
            },
            "token": token.key
        },
        "message": "Login successfully"
    }, status=200)



@api_view(['POST'])
@permission_classes([AllowAny])
def register_user(request):
    email = request.data.get('email')
    password = request.data.get('password')
    name = request.data.get('name')

    if User.objects.filter(email=email).exists():
        return Response({"message": "هذا الحساب مسجل مسبقاً"}, status=400)

    try:
        user = User.objects.create_user(username=email, email=email, password=password)
        user.first_name = name
        user.save()

        return Response({
            "data": {"id": user.id},
            "message": "User created successfully. Please login to get your token."
        }, status=201)
    except Exception as e:
        return Response({"message": str(e)}, status=400)


class UserManagementViewSet(viewsets.ModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = [AllowAny]
