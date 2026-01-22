from django.contrib import admin
from .models import Device, Appointment  # تأكد من تغيير الاسم هنا

admin.site.register(Device)
admin.site.register(Appointment)

from .models import Holiday

@admin.register(Holiday)
class HolidayAdmin(admin.ModelAdmin):
    list_display = ('date', 'reason')
    ordering = ('-date',)