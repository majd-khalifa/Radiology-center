from datetime import datetime

from django.shortcuts import get_object_or_404
from django.contrib.auth.models import User

from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import (
    IsAuthenticated,
    IsAdminUser,
    AllowAny
)
from rest_framework.authentication import TokenAuthentication
from rest_framework import status
from .models import Device, Appointment
from .serializers import DeviceSerializer, AppointmentSerializer
from .utils import generate_device_appointments
from rest_framework.permissions import IsAuthenticated, IsAdminUser



# ===========================
# Devices List & Create
# ===========================
class DeviceListView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        devices = Device.objects.all()
        serializer = DeviceSerializer(devices, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

    def post(self, request):
        if not request.user.is_staff:
            return Response(
                {"message": "Admin only"},
                status=status.HTTP_403_FORBIDDEN
            )

        serializer = DeviceSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(
                serializer.data,
                status=status.HTTP_201_CREATED
            )

        return Response(
            serializer.errors,
            status=status.HTTP_400_BAD_REQUEST
        )


# ===========================
# Device Detail (GET / PUT / PATCH / DELETE)
# ===========================
class DeviceDetailView(APIView):

    def get_permissions(self):
        if self.request.method == 'GET':
            return [IsAuthenticated()]
        return [IsAdminUser()]

    def get(self, request, device_id):
        device = get_object_or_404(Device, id=device_id)
        serializer = DeviceSerializer(device)
        return Response(serializer.data)

    def put(self, request, device_id):
        device = get_object_or_404(Device, id=device_id)
        serializer = DeviceSerializer(device, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=400)

    def patch(self, request, device_id):
        device = get_object_or_404(Device, id=device_id)
        serializer = DeviceSerializer(
            device,
            data=request.data,
            partial=True
        )
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=400)

    def delete(self, request, device_id):
        device = get_object_or_404(Device, id=device_id)
        device.delete()
        return Response(
            {"message": "Device deleted successfully"},
            status=status.HTTP_204_NO_CONTENT
        )

# ============================
#   Appointments
# ============================
class GetAvailableAppointmentsView(APIView):
    """
    GET -> جلب المواعيد المتاحة لجهاز معيّن
    """

    def get(self, request, device_id):
        device = get_object_or_404(Device, id=device_id)

        # توليد المواعيد تلقائيًا
        generate_device_appointments(device, datetime.now().date())

        appointments = Appointment.objects.filter(
            device=device,
            is_available=True
        ).order_by('time')

        serializer = AppointmentSerializer(appointments, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

class AllAppointmentsView(APIView):
    permission_classes = [IsAdminUser]

    def get(self, request):
        appointments = Appointment.objects.all().order_by('date', 'time')
        serializer = AppointmentSerializer(appointments, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)


class AdminCreateAppointmentView(APIView):
    permission_classes = [IsAdminUser]

    def post(self, request):
        serializer = AppointmentSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=201)
        return Response(serializer.errors, status=400)

class AdminUpdateAppointmentView(APIView):
    permission_classes = [IsAdminUser]

    def put(self, request, appointment_id):
        appointment = get_object_or_404(Appointment, id=appointment_id)
        serializer = AppointmentSerializer(
            appointment,
            data=request.data,
            partial=True
        )
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=200)
        return Response(serializer.errors, status=400)

class AdminDeleteAppointmentView(APIView):
    permission_classes = [IsAdminUser]

    def delete(self, request, appointment_id):
        appointment = get_object_or_404(Appointment, id=appointment_id)
        appointment.delete()
        return Response({"message": "Deleted"}, status=204)



class BookAppointmentView(APIView):
    """
    POST -> حجز موعد
    """
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]
    def post(self, request, appointment_id):
        appointment = get_object_or_404(Appointment, id=appointment_id)

        if not appointment.is_available:
            return Response(
                {"error": "الموعد محجوز مسبقًا"},
                status=status.HTTP_400_BAD_REQUEST
            )

        # منع حجز أكثر من موعد بنفس الوقت
        if Appointment.objects.filter(
            patient=request.user,
            date=appointment.date,
            time=appointment.time
        ).exists():
            return Response(
                {"error": "لديك موعد آخر في نفس الوقت"},
                status=status.HTTP_400_BAD_REQUEST
            )

        appointment.patient = request.user
        appointment.is_available = False
        appointment.save()

        return Response(
            {"message": "تم الحجز بنجاح"},
            status=status.HTTP_200_OK
        )


class UpdateAppointmentView(APIView):
    """
    PUT -> تعديل موعد خاص بالمستخدم
    """
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def put(self, request, appointment_id):
        appointment = get_object_or_404(
            Appointment,
            id=appointment_id,
            patient=request.user
        )

        serializer = AppointmentSerializer(
            appointment,
            data=request.data,
            partial=True
        )

        if serializer.is_valid():
            serializer.save()
            return Response(
                {
                    "message": "تم التحديث بنجاح",
                    "data": serializer.data
                },
                status=status.HTTP_200_OK
            )

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class DeleteAppointmentView(APIView):
    """
    DELETE -> إلغاء الحجز
    """
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def delete(self, request, appointment_id):
        appointment = get_object_or_404(
            Appointment,
            id=appointment_id,
            patient=request.user
        )

        appointment.patient = None
        appointment.is_available = True
        appointment.save()

        return Response(
            {"message": "تم إلغاء الحجز بنجاح"},
            status=status.HTTP_200_OK
        )


# ============================
#   Admin Reports
# ============================
@api_view(['GET'])
@permission_classes([IsAdminUser])
def get_booked_appointments(request):
    """
    GET -> جميع المواعيد المحجوزة (Admin)
    """
    appointments = Appointment.objects.filter(
        is_available=False
    ).select_related('patient', 'device')

    data = [
        {
            "appointment_id": app.id,
            "device": app.device.name,
            "date": str(app.date),
            "time": str(app.time),
            "booked_by": {
                "id": app.patient.id,
                "username": app.patient.username,
                "email": app.patient.email
            }
        }
        for app in appointments
        if app.patient
    ]

    return Response(
        {"data": data},
        status=status.HTTP_200_OK
    )

# أضف هذا الكود في نهاية ملف views.py
@api_view(['GET'])
@permission_classes([IsAuthenticated])
def my_appointments(request):
    """
    GET -> جلب المواعيد الخاصة بالمستخدم المسجل حالياً
    """
    appointments = Appointment.objects.filter(patient=request.user)
    serializer = AppointmentSerializer(appointments, many=True)
    return Response(serializer.data, status=status.HTTP_200_OK)