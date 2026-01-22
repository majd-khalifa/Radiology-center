from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from rest_framework.decorators import api_view, permission_classes
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
        device = get_object_or_404(Device, id=device_id)
        generate_device_appointments(device, datetime.now().date())
        
        appointments = Appointment.objects.filter(
            device_id=device_id,
            is_available=True
        ).order_by('time')

        serializer = AppointmentSerializer(appointments, many=True)
        return Response(serializer.data) # تم إصلاح الإزاحة هنا (كانت متراجعة للداخل)

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

        appointment.patient = request.user
        appointment.is_available = False
        if hasattr(appointment, 'status'):
            appointment.status = 'booked'
            
        appointment.save()

        return Response(
            {"message": "تم الحجز بنجاح"},
            status=status.HTTP_200_OK
        )

# ============================
#   تعديل وحذف المواعيد (التي طلبتها)
# ============================
class UpdateAppointmentView(APIView):
    permission_classes = [IsAuthenticated]

    def put(self, request, appointment_id):
        # التأكد أن الموعد يخص المستخدم الحالي
        appointment = get_object_or_404(Appointment, id=appointment_id, patient=request.user)
        serializer = AppointmentSerializer(appointment, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response({"message": "تم التحديث بنجاح", "data": serializer.data})
        return Response(serializer.errors, status=400)

class DeleteAppointmentView(APIView):
    permission_classes = [IsAuthenticated]

    def delete(self, request, appointment_id):
        # البحث عن الموعد وحذفه (إتاحته مرة أخرى)
        appointment = get_object_or_404(Appointment, id=appointment_id, patient=request.user)
        appointment.patient = None
        appointment.is_available = True
        if hasattr(appointment, 'status'):
            appointment.status = 'available'
        appointment.save()
        return Response({"message": "تم إلغاء الحجز بنجاح"}, status=status.HTTP_200_OK)

# ============================
#   جلب المواعيد المحجوزة (تم إصلاح الإزاحة والاستيرادات)
# ============================
@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_booked_appointments(request):
    """
    هذه الدالة تعيد المواعيد المحجوزة مع بيانات المستخدم والـ ID
    """
    try:
        # استخدام patient و is_available=False لضمان جلب البيانات
        booked_list = Appointment.objects.filter(is_available=False).select_related('patient')
        
        results = []
        for app in booked_list:
            if app.patient:
                results.append({
                    "appointment_id": app.id,
                    "date": str(app.date),
                    "time": str(app.time),
                    "booked_by": {
                        "id": app.patient.id,  # الـ ID المطلوب
                        "name": app.patient.first_name if app.patient.first_name else app.patient.username,
                        "email": app.patient.email
                    }
                })
        
        return Response({
            "data": results, 
            "message": "Success"
        }, status=status.HTTP_200_OK)
        
    except Exception as e:
        return Response({"error": str(e)}, status=status.HTTP_400_BAD_REQUEST)