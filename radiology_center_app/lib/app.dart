import 'package:flutter/material.dart';
import 'package:radiology_center_app/core/style/apptheme/app_theme.dart';
import 'views/patient_dashboard.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Radiology Center',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const PatientDashboard(),
    );
  }
}
