from datetime import datetime, timedelta
from .models import Appointment

def generate_device_appointments(device, start_date, days=7):
    """
    توليد مواعيد كل 30 دقيقة لأكثر من يوم:
    الفترة 1: 08:00 إلى 13:00
    الاستراحة: 13:00 إلى 15:00 (مستبعدة)
    الفترة 2: 15:00 إلى 19:00
    """
    shifts = [
        ("08:00", "13:00"),
        ("15:00", "19:00")
    ]

    for day_offset in range(days):  # loop على عدد الأيام
        target_date = start_date + timedelta(days=day_offset)

        for start_str, end_str in shifts:
            current_time = datetime.strptime(start_str, "%H:%M").time()
            end_time = datetime.strptime(end_str, "%H:%M").time()

            current_dt = datetime.combine(target_date, current_time)
            end_dt = datetime.combine(target_date, end_time)

            while current_dt < end_dt:
                Appointment.objects.get_or_create(
                    device=device,
                    date=target_date,
                    time=current_dt.time(),
                    defaults={"is_available": True}
                )
                current_dt += timedelta(minutes=30)
