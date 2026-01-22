from django.urls import path
from .views import DeviceListView, GetAvailableAppointmentsView, BookAppointmentView

urlpatterns = [
    path('devices/', DeviceListView.as_view()),
    path('devices/<int:device_id>/appointments/', GetAvailableAppointmentsView.as_view()),
    path('appointments/<int:appointment_id>/book/', BookAppointmentView.as_view()),
]
