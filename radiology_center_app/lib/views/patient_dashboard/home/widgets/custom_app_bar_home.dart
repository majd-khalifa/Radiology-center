import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:radiology_center_app/core/constant/app_color.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget leftWidget;

  const CustomAppBar({super.key, required this.leftWidget});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: 42, height: 42, child: leftWidget),
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: silver,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/icons/bell.svg',
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(black, BlendMode.srcIn),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(66);
}
