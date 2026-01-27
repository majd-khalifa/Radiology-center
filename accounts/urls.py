from django.urls import path, include
from rest_framework.routers import DefaultRouter
# أضفناlogout_view و profile_view هنا لأنها كانت ناقصة في الاستدعاء
from .views import (
    login_view, 
    register_user, 
    logout_view, 
    profile_view, 
    UserManagementViewSet
)

router = DefaultRouter()
router.register(r'users', UserManagementViewSet, basename='user-manage')

urlpatterns = [
    path('login/', login_view, name='login'),
    path('register/', register_user, name='register'),
    path('logout/', logout_view, name='logout'),
    path('profile/', profile_view, name='profile'),
    # دمج روابط إدارة المستخدمين
    path('', include(router.urls)),
]