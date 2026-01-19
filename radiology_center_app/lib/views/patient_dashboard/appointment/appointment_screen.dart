// views/patient_dashboard/appointment/appointment_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radiology_center_app/core/constant/app_color.dart';
import 'package:radiology_center_app/core/constant/text_style.dart';
import 'package:radiology_center_app/core/widgets/background_image.dart';
import 'package:radiology_center_app/core/widgets/custom_app_bar.dart';
import 'package:radiology_center_app/views/patient_dashboard/appointment/widgets/appointment_date_item.dart';
import 'package:radiology_center_app/views/patient_dashboard/appointment/widgets/device_info_card.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  int selectedDateIndex = 1;
  String? selectedTime;

  final List<String> afternoonSlots = [
    "1:00 PM",
    "1:30 PM",
    "2:00 PM",
    "2:30 PM",
    "3:00 PM",
    "3:30 PM",
    "4:00 PM",
  ];
  final List<String> eveningSlots = [
    "5:00 PM",
    "5:30 PM",
    "6:00 PM",
    "6:30 PM",
    "7:00 PM",
  ];

  @override
  Widget build(BuildContext context) {
    return Backgroundimage(
      child: Scaffold(
        backgroundColor: AppColor.gradientWhite,
        body: SafeArea(
          child: Column(
            children: [
              const CustomAppBar(title: "Select Time"),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const DeviceInfoCard(),
                      SizedBox(height: 25.h),

                      // اختيار التاريخ
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            AppointmentDateItem(
                              day: "Today, 23 Feb",
                              subtitle: "No slots available",
                              isSelected: selectedDateIndex == 0,
                              onTap: () =>
                                  setState(() => selectedDateIndex = 0),
                            ),
                            SizedBox(width: 10.w),
                            AppointmentDateItem(
                              day: "Tomorrow, 24 Feb",
                              subtitle: "9 slots available",
                              isSelected: selectedDateIndex == 1,
                              onTap: () =>
                                  setState(() => selectedDateIndex = 1),
                            ),
                            SizedBox(width: 10.w),
                            AppointmentDateItem(
                              day: "Thu, 25 Feb",
                              subtitle: "10 slots available",
                              isSelected: selectedDateIndex == 2,
                              onTap: () =>
                                  setState(() => selectedDateIndex = 2),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 25.h),
                      Center(
                        child: Text(
                          "Today, 23 Feb",
                          style: AppTextStyles.textStyle18.copyWith(
                            color: AppColor.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),

                      _buildTimeGrid("Afternoon 7 slots", afternoonSlots),
                      SizedBox(height: 20.h),
                      _buildTimeGrid("Evening 5 slots", eveningSlots),
                      SizedBox(height: 30.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeGrid(String title, List<String> times) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.textStyle16.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColor.black,
          ),
        ),
        SizedBox(height: 15.h),
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: times
              .map(
                (time) => TimeSlotItem(
                  time: time,
                  isSelected: selectedTime == time,
                  onTap: () => setState(() => selectedTime = time),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
