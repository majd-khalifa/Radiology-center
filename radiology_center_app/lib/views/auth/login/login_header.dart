import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radiology_center_app/core/constant/app_color.dart';
import 'package:radiology_center_app/core/constant/text_style.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 284.w,
      height: 82.h,
      child: Column(
      
        children: [
          Text(
            "Welcome back",
            style: AppTextStyles.textStyle24.copyWith(
              color: black,
              letterSpacing: -0.3,
              height: 1,
            ),
          ),
          SizedBox(height: 8),
          Text(
            textAlign: TextAlign.center,
            "You can search c ourse, apply course and find scholarship for abroad studies",
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
