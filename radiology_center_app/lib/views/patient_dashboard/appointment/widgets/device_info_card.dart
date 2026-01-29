// ignore_for_file: deprecated_member_use, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radiology_center_app/core/constant/app_color.dart';
import 'package:radiology_center_app/core/constant/text_style.dart';
import 'package:radiology_center_app/models/device_model.dart';

class DeviceInfoCard extends StatelessWidget {
  final DeviceModel device;

  const DeviceInfoCard({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // صورة الجهاز (ثابتة أو من API)
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.asset(
              _getDeviceImage(device.name),
              width: 80.w,
              height: 80.h,
              fit: BoxFit.cover,
            ),
          ),

          SizedBox(width: 15.w),

          // معلومات الجهاز
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  device.name,
                  style: AppTextStyles.textStyle16.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColor.black,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  device.description,
                  style: AppTextStyles.textStyle12.copyWith(
                    color: AppColor.subtitleColor,
                  ),
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 18.sp),
                    SizedBox(width: 4.w),
                    Text(
                      device.rating.toString(),
                      style: AppTextStyles.textStyle14.copyWith(
                        color: AppColor.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🔥 اختيار صورة مناسبة حسب اسم الجهاز
  String _getDeviceImage(String name) {
    if (name.toLowerCase().contains("x"))
      return 'assets/images/xray_machine.webp';
    if (name.toLowerCase().contains("ultra"))
      return 'assets/images/ultrasound.webp';
    if (name.toLowerCase().contains("mri")) return 'assets/images/mri.jpg';
    return 'assets/images/onboarding1.png';
  }
}
