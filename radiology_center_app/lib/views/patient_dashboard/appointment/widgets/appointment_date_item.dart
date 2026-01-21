// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radiology_center_app/core/constant/app_color.dart';
import 'package:radiology_center_app/core/constant/text_style.dart';

class AppointmentDateItem extends StatelessWidget {
  final String day;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const AppointmentDateItem({
    super.key,
    required this.day,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160.w,
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.buttonBackground : AppColor.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isSelected ? AppColor.buttonBackground : AppColor.silver,
          ),
        ),
        child: Column(
          children: [
            Text(
              day,
              style: AppTextStyles.textStyle14.copyWith(
                color: isSelected ? AppColor.white : AppColor.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              subtitle,
              style: AppTextStyles.textStyle12.copyWith(
                color: isSelected
                    ? AppColor.white.withOpacity(0.8)
                    : AppColor.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
