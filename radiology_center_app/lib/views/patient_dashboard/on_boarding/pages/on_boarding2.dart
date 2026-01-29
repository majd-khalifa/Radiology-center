import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radiology_center_app/core/constant/app_color.dart';
import 'package:radiology_center_app/core/constant/text_style.dart';
import 'package:radiology_center_app/views/patient_dashboard/on_boarding/widget/backgroundgreencircle.dart';

class OnBoarding2 extends StatefulWidget {
  const OnBoarding2({super.key});

  @override
  State<OnBoarding2> createState() => _OnBoarding2State();
}

class _OnBoarding2State extends State<OnBoarding2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(top: -20, left: 175, child: Backgroundgreencircle()),

          Positioned(
            child: Column(
              children: [
                SizedBox(height: 91.h),

                Center(
                  child: CircleAvatar(
                    radius: 180.r,
                    backgroundColor: Colors.white,
                    backgroundImage: const AssetImage(
                      "assets/images/onboarding2.webp",
                    ),
                  ),
                ),

                SizedBox(height: 85.h),

                Text(
                  "Book Your Scan Easily",
                  style: AppTextStyles.textStyle28.copyWith(
                    color: AppColor.titleColor,
                  ),
                ),

                SizedBox(height: 11.h),

                SizedBox(
                  width: 289.w,
                  child: Text(
                    textAlign: TextAlign.center,
                    "Schedule X‑Ray, MRI, or Ultrasound appointments in seconds with a smooth and simple booking experience.",
                    style: AppTextStyles.textStyle14.copyWith(
                      color: AppColor.subtitleColor,
                      letterSpacing: -0.3,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
