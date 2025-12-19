import 'package:flutter/material.dart';
import 'package:radiology_center_app/core/style/app_theme.dart';
import 'package:radiology_center_app/views/auth/login/login_screen.dart';
import 'package:radiology_center_app/views/auth/signup/signup_body.dart';
import 'package:radiology_center_app/views/on_boarding/on_boarding_screen.dart';
import 'package:radiology_center_app/views/patient_dashboard/home/home_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Radiology Center',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      routes: {
        '/home': (context) => const PatientDashboard(),
        '/onboarding': (context) => const OnBoardingScreen(),
        '/signup': (context) => const SignupScreen(),
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}
