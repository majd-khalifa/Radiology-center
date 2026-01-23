import 'package:flutter/material.dart';
import 'package:radiology_center_app/core/constant/app_color.dart';
import 'package:radiology_center_app/core/constant/text_style.dart';

class CustomText extends StatelessWidget {
  const CustomText({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.textStyle16.copyWith(
        fontWeight: FontWeight.w500,
        letterSpacing: -0.3,
        color: AppColor.black,
      ),
    );
  }
}
