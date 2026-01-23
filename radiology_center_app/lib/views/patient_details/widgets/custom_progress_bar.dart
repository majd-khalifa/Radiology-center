import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radiology_center_app/core/constant/app_color.dart';

class CustomProgressBar extends StatelessWidget {
  final double progress; // value from 0.0 to 1.0
  final Color backgroundColor;
  final Color fillColor;

  const CustomProgressBar({
    super.key,
    required this.progress,

    this.backgroundColor = AppColor.gradientGreen,
    this.fillColor = AppColor.buttonBackground,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = 1.sw;
        final fillWidth = totalWidth * progress.clamp(0.0, 1.0);

        return Container(
          height: 5.h,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(5.h / 2),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: fillWidth,
                child: Container(
                  decoration: BoxDecoration(
                    color: fillColor,
                    borderRadius: BorderRadius.circular(5.h / 2),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
