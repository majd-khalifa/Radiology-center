// lib/views/admin_dashboard/tabs/appointments_tab.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constant/app_color.dart';
import '../../../../core/constant/text_style.dart';

class AppointmentsTab extends StatelessWidget {
  const AppointmentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(25.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "All Appointments",
            style: AppTextStyles.textStyle24.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20.h),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: ListView.separated(
                itemCount: 15,
                separatorBuilder: (context, index) =>
                    Divider(color: AppColor.silver, height: 1),
                itemBuilder: (context, index) => ListTile(
                  title: Text(
                    "Appointment ID #880$index",
                    style: AppTextStyles.textStyle14.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    "Date: 2024-05-12 | Time: 02:00 PM",
                    style: AppTextStyles.textStyle12,
                  ),
                  trailing: Icon(Icons.info_outline, color: AppColor.iconblue),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
