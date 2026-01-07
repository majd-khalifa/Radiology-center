from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from .models import Appointment, Device
from .utils import generate_device_appointments
from .serializers import AppointmentSerializer
from datetime import datetime

class GetAvailableAppointmentsView(APIView):
    def get(self, request, device_id):
        device = Device.objects.get(id=device_id)
        # توليد مواعيد لليوم
        generate_device_appointments(device, datetime.now().date())
        
        # جلب المواعيد المتاحة
        appointments = Appointment.objects.filter(
            device_id=device_id, 
            is_available=True
        ).order_by('time')
        
        # تحويل البيانات إلى JSON باستخدام السيريالايزر
        serializer = AppointmentSerializer(appointments, many=True)
        return Response(serializer.data)

class BookAppointmentView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, appointment_id):
        try:
            appointment = Appointment.objects.get(id=appointment_id)
            
            if not appointment.is_available:
                return Response({"error": "الموعد محجوز مسبقاً"}, status=status.HTTP_400_BAD_REQUEST)
            
            # حجز الموعد للمستخدم الحالي
            appointment.patient = request.user
            appointment.is_available = False
            appointment.save()
            
            return Response({"message": "تم الحجز بنجاح"}, status=status.HTTP_200_OK)
        except Appointment.DoesNotExist:
            return Response({"error": "الموعد غير موجود"}, status=status.HTTP_404_NOT_FOUND)