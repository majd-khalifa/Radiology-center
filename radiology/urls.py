from django.urls import path
from .views import GetAvailableAppointmentsView, BookAppointmentView

urlpatterns = [
    # رابط لجلب المواعيد لجهاز معين
    path('devices/<int:device_id>/appointments/', GetAvailableAppointmentsView.as_view()),
    # رابط لتنفيذ الحجز
    path('appointments/<int:appointment_id>/book/', BookAppointmentView.as_view()),
]