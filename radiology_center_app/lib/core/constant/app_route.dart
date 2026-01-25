import 'package:flutter/material.dart';
import 'package:radiology_center_app/views/admin_dashboard/admin_dashboard_screen.dart';
import 'package:radiology_center_app/views/auth/login/login_screen.dart';
import 'package:radiology_center_app/views/auth/signup/signup_body.dart';
import 'package:radiology_center_app/views/patient_dashboard/Ai/ai_analysis_screen.dart';
import 'package:radiology_center_app/views/patient_dashboard/on_boarding/on_boarding_screen.dart';
import 'package:radiology_center_app/views/patient_dashboard/appointment/appointment_screen.dart';
import 'package:radiology_center_app/views/patient_dashboard/home/home_screen.dart';
import 'package:radiology_center_app/views/patient_dashboard/profile/profile_screen.dart';
import 'package:radiology_center_app/views/patient_dashboard/patient_details/patient_details.dart';

class AppRoute {
  static const String home = '/home';
  static const String onboarding = '/onboarding';
  static const String signup = '/signup';
  static const String login = '/login';
  static const String profile = '/profile';
  static const String appointment = '/appointment';
  static const String patientDetails = '/patientDetails';
  static const String adminDashboard = '/adminDashboard';
  static const String aiAnalysis = '/aiAnalysis';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnBoardingScreen());
      case signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case appointment:
        return MaterialPageRoute(builder: (_) => const AppointmentScreen());
      case patientDetails:
        return MaterialPageRoute(builder: (_) => PatientDetails());
      case adminDashboard:
        return MaterialPageRoute(builder: (_) => const AdminDashboardScreen());
      case aiAnalysis:
        return MaterialPageRoute(builder: (_) => const AiAnalysisScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
