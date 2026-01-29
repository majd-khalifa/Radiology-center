import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radiology_center_app/core/constant/app_color.dart';
import 'package:radiology_center_app/core/constant/text_style.dart';
import 'package:radiology_center_app/views/patient_dashboard/on_boarding/widget/backgroundgreencircle.dart';

class OnBoarding3 extends StatefulWidget {
  const OnBoarding3({super.key});

  @override
  State<OnBoarding3> createState() => _OnBoarding3State();
}

class _OnBoarding3State extends State<OnBoarding3> {
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

                Center(
                  child: CircleAvatar(
                    radius: 180.r,
                    backgroundColor: Colors.white,
                    backgroundImage: const AssetImage(
                      "assets/images/onboarding3.jpg",
                    ),
                  ),
                ),

                SizedBox(height: 85.h),

                Text(
                  "Get Accurate Results Faster",
                  style: AppTextStyles.textStyle28.copyWith(
                    color: AppColor.titleColor,
                  ),
                ),

                SizedBox(height: 11.h),

                SizedBox(
                  width: 289.w,
                  child: Text(
                    textAlign: TextAlign.center,
                    "Receive clear imaging reports and benefit from smart AI analysis designed to support better diagnosis.",
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
