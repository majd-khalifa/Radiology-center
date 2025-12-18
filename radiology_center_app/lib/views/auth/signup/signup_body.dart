import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radiology_center_app/core/constant/app_color.dart';
import 'package:radiology_center_app/core/constant/text_style.dart';
import 'package:radiology_center_app/views/auth/login/login_screen.dart';
import 'package:radiology_center_app/views/auth/signup/signupheader.dart';

import 'package:radiology_center_app/views/auth/widgets/my_text_field.dart';
import 'package:radiology_center_app/views/auth/widgets/text_filed_with_action.dart';

import 'package:radiology_center_app/widgets/background_image.dart';
import 'package:radiology_center_app/widgets/green_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final formKey = GlobalKey<FormState>();
  final usernamcontroller = TextEditingController();
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();

  bool obscureText = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Backgroundimage(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(height: 152.h),
                  Signupheader(),
                  SizedBox(height: 67),
                  SizedBox(
                    width: 1.sw,
                    height: 250.h,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Mytextfield(
                          text: "Name",
                          controller: usernamcontroller,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }

                            return null;
                          },
                        ),
                        SizedBox(height: 18),
                        Mytextfield(
                          text: "Email",
                          controller: emailcontroller,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }

                            return null;
                          },
                        ),
                        SizedBox(height: 18),
                        TextFiledWithAction(
                          hinttext: "Password",
                          controller: passwordcontroller,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "please enter a password";
                            }
                            if (value.length < 6) {
                              return "please enter a srtonger password";
                            }
                            return null;
                          },
                          firsticon: Icons.visibility_off,
                          secondicon: Icons.visibility,
                          widget: IconButton(
                            onPressed: () {
                              setState(() {
                                obscureText = !obscureText;
                              });
                            },
                            icon: Icon(
                              obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                          obscureText: obscureText,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 54),
                  GreenButton(
                    widget: Text(
                      "Sign up",
                      style: AppTextStyles.textStyle18.copyWith(
                        color: white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    onPressed: () {
                      if (!formKey.currentState!.validate()) return;
                    },
                  ),
                  SizedBox(height: 17),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Have an account?",
                        style: AppTextStyles.textStyle14.copyWith(
                          color: buttonBackground,
                          letterSpacing: -0.3,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: "Log in",
                            style: AppTextStyles.textStyle14.copyWith(
                              color: buttonBackground,
                              letterSpacing: -0.3,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
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
            ),
          ),
        ),
      ),
    );
  }
}
