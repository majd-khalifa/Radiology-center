import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radiology_center_app/core/constant/app_color.dart';
import 'package:radiology_center_app/views/auth/login/login_header.dart';
import 'package:radiology_center_app/views/auth/login/loginbottom.dart';
import 'package:radiology_center_app/views/auth/widgets/text_filed_with_action.dart';

import 'package:radiology_center_app/widgets/background_image.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final formkey = GlobalKey();
  bool ischecked = false;
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formkey,
          child: Backgroundimage(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(height: 127),
                  LoginHeader(),
                  SizedBox(height: 78),
                  SizedBox(
                    width: 1.sw,
                    height: 217.h,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFiledWithAction(
                          firsticon: Icons.check,
                          secondicon: Icons.error_outline,
                          hinttext: "itsmemamun1@gmail.com",
                          controller: emailcontroller,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }

                            return null;
                          },
                          widget: Icon(
                            Icons.check,
                            color: ischecked ? buttonBackground : subtitleColor,
                          ),
                          obscureText: ischecked,
                        ),
                        const SizedBox(height: 18),
                        TextFiledWithAction(
                          hinttext: "● ● ● ● ● ●",
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
                  const SizedBox(height: 32),
                  Loginbottom(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
