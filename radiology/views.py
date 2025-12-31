from rest_framework import viewsets
from rest_framework.permissions import IsAuthenticated
from .models import Device
from .serializers import DeviceSerializer

class DeviceViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Device.objects.all()
    serializer_class = DeviceSerializer
    # لضمان أن الأشخاص المسجلين فقط (معهم Token) يمكنهم رؤية الأجهزة
    permission_classes = [IsAuthenticated]