import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:radiology_center_app/core/style/colors/color.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // النصوص على اليسار
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome!',
                style: TextStyle(
                  fontFamily: 'Rubik',
                  fontSize: 32,
                  height: 38 / 32,
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
              ),
              Text(
                'Rajesh',
                style: TextStyle(
                  fontFamily: 'Rubik',
                  fontSize: 32,
                  height: 38 / 32,
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'How is it going today?',
                style: TextStyle(
                  fontFamily: 'Rubik',
                  fontSize: 16,
                  height: 24 / 16,
                  color: subtitleColor,
                ),
              ),
              const SizedBox(height: 16),
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
                    style: TextStyle(
                      fontFamily: 'Rubik',
                      fontSize: 14,
                      height: 18 / 14,
                      color: Colors.white,
                    ),
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
            ],
          ),
        ),

        const SizedBox(width: 16),

        // صورة الدكتور على اليمين
        Image.asset(
          'assets/images/doctor.png',
          width: 200,
          height: 233,
          fit: BoxFit.cover,
        ),
      ],
    );
  }
}
