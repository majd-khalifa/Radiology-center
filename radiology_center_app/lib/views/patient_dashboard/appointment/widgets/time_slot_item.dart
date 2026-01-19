// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radiology_center_app/core/constant/app_color.dart';
import 'package:radiology_center_app/core/constant/text_style.dart';

class TimeSlotItem extends StatelessWidget {
  final String time;
  final bool isSelected;
  final VoidCallback onTap;

  const TimeSlotItem({
    super.key,
    required this.time,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColor.buttonBackground
              : AppColor.buttonBackground.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Text(
          time,
          style: AppTextStyles.textStyle14.copyWith(
            color: isSelected ? AppColor.white : AppColor.buttonBackground,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
