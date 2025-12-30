import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radiology_center_app/core/constant/app_color.dart';
import 'package:radiology_center_app/core/constant/text_style.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Welcome back",
          style: AppTextStyles.textStyle24.copyWith(
            color: black,
            letterSpacing: -0.3,
            height: 1,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          "You can search c ourse, apply course and\nfind scholarship for abroad studies",
          textAlign: TextAlign.center,
          style: AppTextStyles.textStyle14.copyWith(
            color: subtitleColor,
            letterSpacing: -0.3,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
//  