// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:radiology_center_app/core/constant/app_color.dart';
import 'package:radiology_center_app/core/constant/text_style.dart';

class RadioItem extends StatelessWidget {
  const RadioItem({
    super.key,
    required this.selectedGender,
    required this.onChanged,
    required this.gender,
  });
  final String selectedGender;
  final Function(String?) onChanged;
  final String gender;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio<String>(
          value: gender,
          groupValue: selectedGender,
          onChanged: onChanged,
        ),
        Text(
          gender,
          style: AppTextStyles.textStyle16.copyWith(
            fontWeight: FontWeight.w300,
            color: AppColor.subtitleColor,
          ),
        ),
      ],
    );
  }
}
