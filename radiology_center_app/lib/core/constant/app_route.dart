import 'package:flutter/material.dart';
import 'package:radiology_center_app/views/auth/login/login_screen.dart';
import 'package:radiology_center_app/views/auth/signup/signup_body.dart';
import 'package:radiology_center_app/views/on_boarding/on_boarding_screen.dart';
import 'package:radiology_center_app/views/patient_dashboard/home/home_page.dart';

class AppRoute {
  static const String home = '/home';
  static const String onboarding = '/onboarding';
  static const String signup = '/signup';
  static const String login = '/login';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const PatientDashboard());
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnBoardingScreen());
      case signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
