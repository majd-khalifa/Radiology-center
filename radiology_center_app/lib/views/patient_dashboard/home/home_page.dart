import 'package:flutter/material.dart';
import 'package:radiology_center_app/core/widgets/custom_app_bar.dart';
import 'package:radiology_center_app/views/patient_dashboard/appointment/appointment_screen.dart';
import 'home_body.dart';
import 'home_header.dart';
import 'package:radiology_center_app/widgets/bottom_nav_bar.dart';

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
            children: const [
              CustomAppBar(
                leftWidget: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/profile.png'),
                  radius: 21,
                ),
              ),
              DashboardHeader(),
              HomeBody(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            // ✅ لما يضغط على Appointment
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AppointmentScreen(),
              ),
            );
          }
        },
      ),
    );
  }
}
