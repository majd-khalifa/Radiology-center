// lib/views/admin_dashboard/widgets/recent_appointments_list.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constant/app_color.dart';
import '../../../../core/constant/text_style.dart';

class RecentAppointmentsList extends StatelessWidget {
  const RecentAppointmentsList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) => Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColor.silver),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundColor: AppColor.silver,
            child: const Icon(Icons.person, color: AppColor.grey),
          ),
          title: Text(
            "Patient Name $index",
            style: AppTextStyles.textStyle14.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            "X-Ray Scan • 10:30 AM",
            style: AppTextStyles.textStyle12,
          ),
          trailing: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColor.buttonBackground.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              "Confirmed",
              style: AppTextStyles.textStyle12.copyWith(
                color: AppColor.buttonBackground,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
