import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radiology_center_app/core/constant/app_color.dart';
import 'package:radiology_center_app/core/constant/text_style.dart';
import 'package:radiology_center_app/widgets/custom_app_bar.dart';
import 'package:radiology_center_app/widgets/scrollable_options.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  int selectedTimeIndex = 2;
  int selectedReminderIndex = 2;

  final List<String> times = [
    "10:00 AM",
    "12:00 AM",
    "02:00 PM",
    "03:00 PM",
    "04:00 PM",
  ];
  final List<String> reminders = ["30", "40", "25", "10", "35"];

  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const CustomAppBar(title: "Appointment"),
              SizedBox(height: 16.h),

              // Calendar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: TableCalendar(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: focusedDay,
                    selectedDayPredicate: (day) => isSameDay(selectedDay, day),
                    onDaySelected: (selected, focused) {
                      setState(() {
                        selectedDay = selected;
                        focusedDay = focused;
                      });
                    },
                    headerStyle: HeaderStyle(
                      titleCentered: true,
                      formatButtonVisible: false,
                      decoration: BoxDecoration(
                        color: buttonBackground,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16.r),
                        ),
                      ),
                      titleTextStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      leftChevronIcon: Icon(
                        Icons.chevron_left,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                      rightChevronIcon: Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                    ),
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: buttonBackground.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: buttonBackground,
                        shape: BoxShape.circle,
                      ),
                      selectedTextStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 28.h),

              // White Section
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.r),
                      topRight: Radius.circular(40.r),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 35.h),
                        Text(
                          "Available Time",
                          style: AppTextStyles.textStyle16.copyWith(
                            color: black,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 27.h),
                        ScrollableOptions(
                          items: times,
                          selectedIndex: selectedTimeIndex,
                          onSelect: (i) =>
                              setState(() => selectedTimeIndex = i),
                        ),
                        SizedBox(height: 38.h),
                        Text(
                          "Remind Me Before",
                          style: AppTextStyles.textStyle16.copyWith(
                            color: black,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 27.h),
                        ScrollableOptions(
                          items: reminders.map((r) => "$r min").toList(),
                          selectedIndex: selectedReminderIndex,
                          onSelect: (i) =>
                              setState(() => selectedReminderIndex = i),
                        ),
                        const Spacer(),
                        SizedBox(
                          height: 54.h,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: buttonBackground,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            child: Text(
                              "Confirm",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
