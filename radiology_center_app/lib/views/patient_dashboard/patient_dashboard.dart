import 'package:flutter/material.dart';
import 'package:radiology_center_app/core/widgets/custom_app_bar.dart';
import 'appointment_section.dart';
import 'dashboard_header.dart';
import 'services_section.dart';

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
              Expanded(
                child: Column(
                  children: [
                    const DashboardHeader(),
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
                          children: const [
                            ServicesSection(),
                            SizedBox(height: 19),
                            AppointmentSection(),
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
