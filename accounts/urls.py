from django.urls import path
from .views import register_user
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView

urlpatterns = [
    path('register/', register_user, name='register'),
    # رابط تسجيل الدخول (يرسل له صديقك الإيميل والباسورد فيعطيه الـ Token)
    path('login/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    # رابط لتجديد الـ Token إذا انتهت صلاحيته
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
]