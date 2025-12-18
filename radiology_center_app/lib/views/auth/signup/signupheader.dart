import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radiology_center_app/core/constant/app_color.dart';
import 'package:radiology_center_app/core/constant/text_style.dart';

class Signupheader extends StatelessWidget {
  const Signupheader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 290.w,
      height: 89.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            textAlign: TextAlign.center,
            "Join us to start searching",
            style: AppTextStyles.textStyle24.copyWith(
              color: black,
              letterSpacing: -0.3,
              height: 1,
            ),
          ),
          SizedBox(height: 15),
          Text(
            textAlign: TextAlign.center,
            "You can search course, apply course and find scholarship for abroad studies",
            style: AppTextStyles.textStyle14.copyWith(
              color: subtitleColor,
              letterSpacing: -0.3,
              height: 1.656,
            ),
          ),
        ],
      ),
    );
  }
}
