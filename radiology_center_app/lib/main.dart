import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radiology_center_app/core/constant/app_font.dart';
import 'package:radiology_center_app/core/constant/app_route.dart';
import 'package:radiology_center_app/views/patient_dashboard/patient_details/patient_details.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          onGenerateRoute: AppRoute.generateRoute,
          theme: ThemeData(
            fontFamily: AppFont.rubik,
            textTheme: const TextTheme(
              bodyMedium: TextStyle(color: Colors.white),
              bodySmall: TextStyle(color: Colors.white70),
            ),
          ),

          initialRoute: AppRoute.login,
        );
      },
      child: PatientDetails(),
    );
  }
}
