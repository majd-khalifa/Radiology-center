import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radiology_center_app/core/constant/app_color.dart';

class Backgroundgreencircle extends StatelessWidget {
  const Backgroundgreencircle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 342.w,
      height: 342.h,
      decoration: BoxDecoration(
        color: buttonBackground,
        shape: BoxShape.circle,
      ),
    );
  }
}
