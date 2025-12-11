import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:radiology_center_app/core/constant/app_color.dart';
import 'package:radiology_center_app/core/constant/text_style.dart';

class CategoryItem extends StatelessWidget {
  final String label;
  final String iconPath;

  const CategoryItem(this.label, this.iconPath, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 65,
          height: 65,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: silver, width: 1.5),
            color: Colors.white,
          ),
          child: Center(
            child: SvgPicture.asset(
              iconPath,
              width: 36,
              height: 36,
              colorFilter: const ColorFilter.mode(iconblue, BlendMode.srcIn),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: AppTextStyles.textStyle12),
      ],
    );
  }
}
