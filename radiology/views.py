from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from django.shortcuts import get_object_or_404
from datetime import datetime

from .models import Appointment, Device
from .utils import generate_device_appointments
from .serializers import AppointmentSerializer, DeviceSerializer


# ============================
#   عرض قائمة الأجهزة
# ============================
class DeviceListView(APIView):
    def get(self, request):
        devices = Device.objects.all()
        serializer = DeviceSerializer(devices, many=True)
        return Response(serializer.data)

    def post(self, request):
        serializer = DeviceSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)



# ============================
#   عرض المواعيد لجهاز معيّن
# ============================
class GetAvailableAppointmentsView(APIView):
    def get(self, request, device_id):
        # إذا الجهاز غير موجود → يرجع 404 بدل 500
        device = get_object_or_404(Device, id=device_id)

        # توليد مواعيد لليوم
        generate_device_appointments(device, datetime.now().date())

        # جلب المواعيد المتاحة
        appointments = Appointment.objects.filter(
            device_id=device_id,
            is_available=True
        ).order_by('time')

        serializer = AppointmentSerializer(appointments, many=True)
        return Response(serializer.data)


# ============================
#   حجز موعد
# ============================
class BookAppointmentView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, appointment_id):
        appointment = get_object_or_404(Appointment, id=appointment_id)

        if not appointment.is_available:
            return Response(
                {"error": "الموعد محجوز مسبقاً"},
                status=status.HTTP_400_BAD_REQUEST
            )

        # حجز الموعد للمستخدم الحالي
        appointment.patient = request.user
        appointment.is_available = False
        appointment.save()

        return Response(
            {"message": "تم الحجز بنجاح"},
            status=status.HTTP_200_OK
        )
