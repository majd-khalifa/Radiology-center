import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radiology_center_app/core/constant/app_color.dart';
import 'package:radiology_center_app/core/constant/text_style.dart';
import 'package:radiology_center_app/views/auth/signup/signup_body.dart';
import 'package:radiology_center_app/widgets/green_button.dart';

class Loginbottom extends StatelessWidget {
  const Loginbottom({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          GreenButton(
            widget: Text(
              "Login",
              style: AppTextStyles.textStyle18.copyWith(
                color: white,
                letterSpacing: -0.3,
              ),
            ),
            onPressed: () {},
          ),
          const SizedBox(height: 19),
          Center(
            child: InkWell(
              child: Text(
                "Forgot password",
                style: AppTextStyles.textStyle14.copyWith(
                  color: buttonBackground,
                  letterSpacing: -0.3,
                ),
              ),
            ),
          ),
          SizedBox(height: 214.h),
          Center(
            child: RichText(
              text: TextSpan(
                text: "Don’t have an account?",
                style: AppTextStyles.textStyle14.copyWith(
                  color: buttonBackground,
                  letterSpacing: -0.3,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: " Join us",
                    style: AppTextStyles.textStyle14.copyWith(
                      color: buttonBackground,
                      letterSpacing: -0.3,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignupScreen(),
                          ),
                        );
                      },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
