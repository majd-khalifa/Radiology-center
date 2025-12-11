import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:radiology_center_app/core/constant/app_color.dart';
import 'package:radiology_center_app/core/constant/text_style.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Welcome!", style: AppTextStyles.textStyle32),
                Text("Rajesh", style: AppTextStyles.textStyle32),
                const SizedBox(height: 4),
                Text(
                  "How is it going today?",
                  style: AppTextStyles.textStyle16,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: 141,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      'assets/icons/urgent.svg',
                      width: 20,
                      height: 20,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    label: Text(
                      'Urgent Care',
                      style: AppTextStyles.textStyle14,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: urgent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Image.asset(
            'assets/images/doctor.png',
            width: 188,
            height: 233,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
