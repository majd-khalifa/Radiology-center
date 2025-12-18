import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radiology_center_app/core/constant/app_color.dart';
import 'package:radiology_center_app/core/constant/text_style.dart';
import 'package:radiology_center_app/views/on_boarding/widget/backgroundgreencircle.dart';

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
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,

                children: [
                  SizedBox(height: 91),
                  SizedBox(
                    width: 380.w,
                    height: 380.h,
                    child: CircleAvatar(
                      radius: 1.sw,
                      child: Image.asset("assets/images/onboaredingimage.png"),
                    ),
                  ),
                  SizedBox(height: 85),
                  Text(
                    "Choose Best Doctors",
                    style: AppTextStyles.textStyle28.copyWith(
                      color: titleColor,
                    ),
                  ),
                  SizedBox(height: 11.h),
                  SizedBox(
                    width: 289,
                    height: 70,
                    child: Text(
                      textAlign: TextAlign.center,
                      "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of it over 2000 years old.",
                      style: AppTextStyles.textStyle14.copyWith(
                        color: subtitleColor,
                        letterSpacing: -0.3,
                        height: 1.656,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
