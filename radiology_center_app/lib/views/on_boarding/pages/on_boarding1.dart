import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radiology_center_app/core/constant/app_color.dart';
import 'package:radiology_center_app/core/constant/text_style.dart';
import 'package:radiology_center_app/views/on_boarding/widget/backgroundgreencircle.dart';

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
              mainAxisAlignment: MainAxisAlignment.start,

              children: [
                SizedBox(height: 91),
                Center(
                  child: SizedBox(
                    width: 380.w,
                    height: 380.h,
                    child: CircleAvatar(
                      radius: 1.sw,
                      child: Image.asset("assets/images/onboaredingimage.png"),
                    ),
                  ),
                ),
                SizedBox(height: 85),
                Text(
                  "Find Trusted Doctors",
                  style: AppTextStyles.textStyle28.copyWith(color: titleColor),
                ),
                SizedBox(height: 11),
                SizedBox(
                  width: 289.w,
                  height: 70.h,
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
        ],
      ),
    );
  }
}
