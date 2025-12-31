from rest_framework import serializers
from .models import Device, TimeSlot

class TimeSlotSerializer(serializers.ModelSerializer):
    class Meta:
        model = TimeSlot
        fields = ['id', 'start_time', 'is_available']

class DeviceSerializer(serializers.ModelSerializer):
    # هذا الجزء سيجلب قائمة المواعيد التابعة لكل جهاز تلقائياً
    slots = TimeSlotSerializer(many=True, read_only=True)

    class Meta:
        model = Device
        fields = ['id', 'name', 'description', 'image', 'price', 'slots']