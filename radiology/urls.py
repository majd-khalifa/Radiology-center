from django.urls import path
from .views import (
    DeviceListView, 
    DeviceDetailView,
    GetAvailableAppointmentsView, 
    BookAppointmentView, 
    UpdateAppointmentView, 
    DeleteAppointmentView,
    get_booked_appointments,
    my_appointments
)

urlpatterns = [
    path('devices/', DeviceListView.as_view()),
    path('devices/<int:device_id>/', DeviceDetailView.as_view()),
    path('devices/<int:device_id>/appointments/', GetAvailableAppointmentsView.as_view()),
    path('appointments/<int:appointment_id>/book/', BookAppointmentView.as_view()),
    path('appointments/<int:appointment_id>/update/', UpdateAppointmentView.as_view(), name='update_appointment'),
    path('appointments/<int:appointment_id>/delete/', DeleteAppointmentView.as_view(), name='delete_appointment'),
    path('booked-appointments/', get_booked_appointments, name='booked_appointments'),
    path('my-appointments/', my_appointments, name='my_appointments'),
]