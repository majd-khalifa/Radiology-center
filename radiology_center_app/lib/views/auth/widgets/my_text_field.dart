import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radiology_center_app/core/constant/app_color.dart';
import 'package:radiology_center_app/core/constant/text_style.dart';

class Mytextfield extends StatelessWidget {
  final String? Function(String?)? validator;
  final String text;
  final TextEditingController controller;
  const Mytextfield({
    super.key,
    required this.text,
    required this.controller,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54.h,
      child: Opacity(
        opacity: 0.6,
        child: TextFormField(
          validator: validator,
          controller: controller,
          decoration: InputDecoration(
            hint: Text(
              text,
              style: AppTextStyles.textStyle16.copyWith(
                color: subtitleColor,
                letterSpacing: -0.3,
                fontWeight: FontWeight.w100,
              ),
            ),
            fillColor: white,
            filled: true,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: BorderSide(
                color: subtitleColor,
                style: BorderStyle.solid,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: subtitleColor,
                style: BorderStyle.solid,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
