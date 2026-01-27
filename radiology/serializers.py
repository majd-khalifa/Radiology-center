from rest_framework import serializers
from .models import Device, Appointment


class AppointmentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Appointment
        fields = ['id', 'date', 'time', 'is_available']


class DeviceSerializer(serializers.ModelSerializer):
    appointments = AppointmentSerializer(
        many=True,
        read_only=True
    )

    class Meta:
        model = Device
        fields = [
            'id',
            'name',
            'specialty',
            'description',
            'image',
            'rating',
            'appointments'
        ]