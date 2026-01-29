import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radiology_center_app/views/patient_dashboard/appointment/my_appointments_screen.dart';
import 'package:radiology_center_app/views/patient_dashboard/home/widgets/custom_app_bar_home.dart';
import 'package:radiology_center_app/core/widgets/bottom_nav_bar.dart';
import 'home_body.dart';
import 'home_header.dart';
import 'package:radiology_center_app/core/constant/app_route.dart';
import 'package:radiology_center_app/views/patient_dashboard/services/our_services_screen.dart';
import 'package:radiology_center_app/views/patient_dashboard/profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  void onTabTapped(int index) {
    if (index == 0) {
      setState(() => currentIndex = 0);
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const MyAppointmentsScreen()),
      ).then((_) {
        setState(() => currentIndex = 0);
      });
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const OurServicesScreen()),
      ).then((_) {
        setState(() => currentIndex = 0);
      });
    } else if (index == 3) {
      Navigator.pushNamed(context, AppRoute.aiAnalysis).then((_) {
        setState(() => currentIndex = 0);
      });
    } else if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ProfileScreen()),
      ).then((_) {
        setState(() => currentIndex = 0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background2.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 20.h),

              const CustomAppBar(
                leftWidget: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/empty.jpg'),
                  radius: 21,
                ),
                title: '',
              ),

              SizedBox(height: 10.h),

              const DashboardHeader(),

              /// ارتفاع ثابت للـ HomeBody باستخدام ScreenUtil
              Expanded(child: const HomeBody()),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: currentIndex,
        onTap: onTabTapped,
      ),
    );
  }
}
