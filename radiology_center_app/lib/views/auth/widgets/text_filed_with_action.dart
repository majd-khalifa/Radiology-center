import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radiology_center_app/core/constant/app_color.dart';
import 'package:radiology_center_app/core/constant/text_style.dart';

class TextFiledWithAction extends StatefulWidget {
  final bool obscureText;
  final Widget widget;
  final String hinttext;
  final IconData firsticon;
  final IconData secondicon;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  const TextFiledWithAction({
    super.key,
    required this.hinttext,
    required this.controller,
    required this.validator,
    required this.firsticon,
    required this.secondicon,
    required this.widget,
    required this.obscureText,
  });

  @override
  State<TextFiledWithAction> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<TextFiledWithAction> {
  double letterspacing = 0;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1.sw,
      height: 48.h,
      child: Opacity(
        opacity: 0.6,
        child: TextFormField(
          obscuringCharacter: '●',
          validator: widget.validator,
          controller: widget.controller,
          obscureText: widget.obscureText,
          decoration: InputDecoration(
            suffixIcon: widget.widget,
            hint: Text(
              textAlign: TextAlign.start,
              widget.hinttext,
              style: AppTextStyles.textStyle16.copyWith(
                color: subtitleColor,
                letterSpacing: -0.3,
                fontWeight: FontWeight.w100,
              ),
            ),
            filled: true,
            fillColor: white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: subtitleColor,
                style: BorderStyle.solid,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
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
