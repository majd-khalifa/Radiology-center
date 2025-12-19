import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radiology_center_app/core/constant/app_color.dart';
import 'package:radiology_center_app/core/constant/text_style.dart';
import 'package:radiology_center_app/widgets/background_image.dart';
import 'package:radiology_center_app/views/on_boarding/pages/on_boarding1.dart';
import 'package:radiology_center_app/views/on_boarding/pages/on_boarding2.dart';
import 'package:radiology_center_app/views/on_boarding/pages/on_boarding3.dart';
import 'package:radiology_center_app/widgets/green_button.dart';
// import 'package:radiology_center_app/views/patient_dashboard/home/home_page.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  final List<Widget> pages = const [
    OnBoarding1(),
    OnBoarding2(),
    OnBoarding3(),
  ];
  void nextPage() {
    if (currentPage < pages.length - 1) {
      _pageController.animateToPage(
        currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Backgroundimage(
        child: Stack(
          children: [
            PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => currentPage = index);
              },
              children: pages,
            ),
            Positioned(
              right: 31.w,
              left: 49.w,
              bottom: 80.h,
              child: Column(
                children: [
                  GreenButton(
                    widget: Text(
                      currentPage == 0 ? "Get Started" : "Next",
                      style: AppTextStyles.textStyle18.copyWith(color: white),
                    ),
                    onPressed: () => nextPage(),
                  ),
                  SizedBox(height: 14),
                  Center(
                    child: InkWell(
                      child: Text(
                        "Skip",
                        style: AppTextStyles.textStyle14.copyWith(
                          color: subtitleColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
