import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radiology_center_app/core/constant/app_color.dart';

class Backgroundimage extends StatelessWidget {
  final Widget child;
  const Backgroundimage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      height: 1.sh,
      decoration: BoxDecoration(
        color: AppColor.white,
        image: DecorationImage(
          image: AssetImage("assets/images/onboarding_BG.png"),
          fit: BoxFit.fitWidth,
        ),
      ),
      child: Center(child: child),
    );
  }
}
