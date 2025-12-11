import 'package:flutter/material.dart';
import 'package:radiology_center_app/core/widgets/custom_app_bar.dart';
import 'home_body.dart';
import 'home_header.dart';

class PatientDashboard extends StatelessWidget {
  const PatientDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const CustomAppBar(
                leftWidget: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/profile.png'),
                  radius: 21,
                ),
              ),
              const DashboardHeader(),
              const HomeBody(), // هنا صار كل الـ Services + Appointment
            ],
          ),
        ),
      ),
    );
  }
}
