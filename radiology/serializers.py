from rest_framework import serializers
from .models import Device, Appointment

class AppointmentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Appointment
        fields = ['id', 'time', 'date', 'is_available']

class DeviceSerializer(serializers.ModelSerializer):
    # هذا السطر يسمح بجلب المواعيد التابعة لكل جهاز عند طلبه
    appointments = AppointmentSerializer(many=True, read_only=True)

    class Meta:
        model = Device
        fields = ['id', 'name', 'appointments'] # أضف باقي حقول الجهاز هنا