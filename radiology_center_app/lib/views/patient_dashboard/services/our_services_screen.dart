// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:radiology_center_app/core/constant/app_color.dart';
import 'package:radiology_center_app/core/constant/text_style.dart';
import 'package:radiology_center_app/core/widgets/custom_app_bar.dart';
import 'package:radiology_center_app/views/patient_dashboard/appointment/appointment_screen.dart';

class OurServicesScreen extends StatelessWidget {
  const OurServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3FFF8),

      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(title: "Our Services"),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _serviceItem(
                    context,
                    title: "X-Ray",
                    iconPath: 'assets/icons/skeleton.svg',
                    deviceId: 1,
                  ),
                  _serviceItem(
                    context,
                    title: "MRI",
                    iconPath: 'assets/icons/mri.svg',
                    deviceId: 3,
                  ),
                  _serviceItem(
                    context,
                    title: "Ultrasound",
                    iconPath: 'assets/icons/ultrasound.svg',
                    deviceId: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _serviceItem(
    BuildContext context, {
    required String title,
    required String iconPath,
    required int deviceId,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AppointmentScreen(deviceId: deviceId),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // نفس الأيقونات المستخدمة في HomeBody
            SvgPicture.asset(
              iconPath,
              width: 40,
              height: 40,
              colorFilter: const ColorFilter.mode(
                AppColor.homeIcons,
                BlendMode.srcIn,
              ),
            ),

            const SizedBox(width: 16),

            Text(
              title,
              style: AppTextStyles.textStyle18.copyWith(
                color: AppColor.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
