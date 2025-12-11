import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constant/app_color.dart';

class AppTheme {
  // Gradient decoration
  static const LinearGradient mainGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [gradientBlue, gradientWhite, gradientWhite, gradientGreen],
    stops: [0.0, 0.3, 0.75, 1.0],
  );

  static BoxDecoration gradientBackground = const BoxDecoration(
    gradient: mainGradient,
  );

  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor:
          Colors.transparent, // transparent to show gradient
      fontFamily: 'Raleway',

      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: titleColor,
        secondary: buttonBackground,
      ),

      textTheme: TextTheme(
        bodyMedium: TextStyle(fontSize: 14.sp, color: subtitleColor),
        bodyLarge: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: titleColor,
        ),
        titleLarge: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: titleColor,
        ),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: white,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: titleColor,
        ),
        iconTheme: const IconThemeData(color: titleColor),
      ),

      buttonTheme: ButtonThemeData(
        buttonColor: buttonBackground,
        textTheme: ButtonTextTheme.primary,
      ),
    );
  }
}
