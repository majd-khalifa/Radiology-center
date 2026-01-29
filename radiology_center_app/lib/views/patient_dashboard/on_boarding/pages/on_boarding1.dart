import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radiology_center_app/core/constant/app_color.dart';
import 'package:radiology_center_app/core/constant/text_style.dart';
import 'package:radiology_center_app/views/patient_dashboard/on_boarding/widget/backgroundgreencircle.dart';

class OnBoarding1 extends StatefulWidget {
  const OnBoarding1({super.key});

  @override
  State<OnBoarding1> createState() => _OnBoarding1State();
}

class _OnBoarding1State extends State<OnBoarding1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(top: -20, left: -104, child: Backgroundgreencircle()),

          Positioned(
            child: Column(
              children: [
                SizedBox(height: 91.h),

                // صورة دائرية
                Center(
                  child: CircleAvatar(
                    radius: 180.r,
                    backgroundColor: Colors.white,
                    backgroundImage: const AssetImage(
                      "assets/images/onboarding1.png",
                    ),
                  ),
                ),

                SizedBox(height: 85.h),

                Text(
                  "Advanced Radiology Services",
                  style: AppTextStyles.textStyle28.copyWith(
                    color: AppColor.titleColor,
                  ),
                ),

                SizedBox(height: 11.h),

                SizedBox(
                  width: 289.w,
                  child: Text(
                    textAlign: TextAlign.center,
                    "Access modern imaging technology designed to give you accurate, fast, and reliable results.",
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
