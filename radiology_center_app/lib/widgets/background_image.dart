import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class Backgroundimage extends StatelessWidget {
  final Widget child;
  const Backgroundimage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      height: 1.sh,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/onboarding_BG.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(child: child),
    );
  }
}
