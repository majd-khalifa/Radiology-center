import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radiology_center_app/core/constant/app_color.dart';

class GreenButton extends StatelessWidget {
  const GreenButton({super.key, required this.widget, required this.onPressed});

  final Widget widget;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1.sw,
      height: 54.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          backgroundColor: buttonBackground,
        ),

        onPressed: () {},
        child: widget,
      ),
    );
  }
}
