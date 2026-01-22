// core/widgets/background_image.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radiology_center_app/core/constant/app_color.dart';
import 'package:radiology_center_app/core/constant/app_image.dart';

class Backgroundimage extends StatelessWidget {
  final Widget child;
  const Backgroundimage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      height: 1.sh,
      decoration: BoxDecoration(
        color: AppColor.white, // ضمان وجود خلفية بيضاء لعدم ظهور السواد
        image: DecorationImage(
          image: AssetImage(AppImage.onbordingbackground),
          fit: BoxFit.cover,
          // colorFilter: ColorFilter.mode(
          //   // AppColor.white.withOpacity(0.9), // تفتيح الصورة لتظهر النصوص بوضوح
          //   // BlendMode.lighten,
          // ),
        ),
      ),
      child: child,
    );
  }
}
