import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:radiology_center_app/core/constant/app_color.dart';
import 'package:radiology_center_app/core/widgets/custom_app_bar.dart';
import '../core/constant/text_style.dart';

class PatientDashboard extends StatelessWidget {
  const PatientDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // الخلفية نفسها لكل الصفحة
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"), // مسار الصورة
            fit: BoxFit.cover, // تغطي الشاشة كاملة
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // AppBar مدمج مع الخلفية
              CustomAppBar(
                leftWidget: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/images/profile.png',
                    width: 42,
                    height: 42,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // باقي الصفحة
              Expanded(
                child: Column(
                  children: [
                    // النصوص + صورة الدكتور
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 0,
                      ),
                      child: Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.end, // يخلي الصورة تنزل لتحت
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Welcome!",
                                  style: AppTextStyles.textStyle32,
                                ),
                                Text(
                                  "Rajesh",
                                  style: AppTextStyles.textStyle32,
                                ),
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
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 30),
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
                    ),

                    // Body الأبيض بزوايا دائرية
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(23),
                            topRight: Radius.circular(23),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Text(
                                "Our Services",
                                style: AppTextStyles.textStyle16.copyWith(
                                  color: black,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildCategory(
                                    "Consultation",
                                    'assets/icons/consultation.svg',
                                  ),
                                  _buildCategory(
                                    "Medicines",
                                    'assets/icons/medicines.svg',
                                  ),
                                  _buildCategory(
                                    "Ambulance",
                                    'assets/icons/ambulance.svg',
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 19),

                            // Appointment Section
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Appointment",
                                    style: AppTextStyles.textStyle16.copyWith(
                                      color: black,
                                    ),
                                  ),
                                  Text(
                                    "See All",
                                    style: AppTextStyles.textStyle14,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16),
                            // Appointment Card (UI فقط حالياً)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Container(
                                height: 120,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: Text("Appointment Card Placeholder"),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildCategory(String label, String iconPath) {
  return Column(
    children: [
      // الأيقونة داخل إطار مدور
      Container(
        width: 65,
        height: 65,
        decoration: BoxDecoration(
          shape: BoxShape.circle, // يجعلها دائرية تمامًا
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

      // النص خارج الكونتينر
      Text(label, style: AppTextStyles.textStyle12),
    ],
  );
}
