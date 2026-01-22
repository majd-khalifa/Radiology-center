from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import login_view, register_user, UserManagementViewSet

router = DefaultRouter()
router.register(r'users', UserManagementViewSet, basename='user-manage')

urlpatterns = [
    path('login/', login_view, name='login'),
    path('register/', register_user, name='register'),
    # دمج روابط إدارة المستخدمين
    path('', include(router.urls)),
]