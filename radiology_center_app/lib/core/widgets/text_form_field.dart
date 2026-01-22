// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radiology_center_app/core/constant/app_color.dart';
import 'package:radiology_center_app/core/constant/text_style.dart';

class CustomTextFormField extends StatelessWidget {
  final String? label;
  final String hintText;
  final TextEditingController? controller;
  final bool hasEditIcon;
  final TextInputType keyboardType;
  final VoidCallback? onEditPressed;

  const CustomTextFormField({
    super.key,
    this.label,
    required this.hintText,
    this.controller,
    this.hasEditIcon = false,
    this.keyboardType = TextInputType.text,
    this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColor.silver),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label??" ",
                  style: AppTextStyles.textStyle12.copyWith(
                    color: AppColor.buttonBackground,
                  ),
                ),
                TextFormField(
                  controller: controller,
                  keyboardType: keyboardType,
                  style: AppTextStyles.textStyle16.copyWith(
                    color: AppColor.subtitleColor,
                  ),
                  decoration: InputDecoration(
                    isDense: true, // لتقليل المسافات الداخلية
                    hintText: hintText,
                    hintStyle: AppTextStyles.textStyle16.copyWith(
                      color: AppColor.grey.withOpacity(0.6),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 4.h),
                  ),
                ),
              ],
            ),
          ),
          if (hasEditIcon)
            GestureDetector(
              onTap: onEditPressed,
              child: Icon(Icons.edit, color: AppColor.grey, size: 18.r),
            ),
        ],
      ),
    );
  }
}
