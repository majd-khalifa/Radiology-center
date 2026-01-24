// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:radiology_center_app/core/constant/app_color.dart';
import 'package:radiology_center_app/core/helper/snack_bar_helper.dart';
import 'package:radiology_center_app/core/services/api/api_link.dart';
import 'package:radiology_center_app/core/services/api/api_services.dart';
import 'package:radiology_center_app/core/services/auth_service.dart';
import 'package:radiology_center_app/views/auth/login/login_header.dart';
import 'package:radiology_center_app/views/auth/login/loginbottom.dart';
import 'package:radiology_center_app/views/auth/widgets/text_filed_with_action.dart';
import 'package:radiology_center_app/core/widgets/background_image.dart';
import 'package:radiology_center_app/views/patient_dashboard/home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final formkey = GlobalKey<FormState>();
  bool ischecked = false;
  bool obscureText = true;

  final ApiServices api = ApiServices();
  Future<bool> login({required String email, required String password}) async {
    try {
      final response = await api.postData(
        url: ApiLink.login,
        body: {'email': email, 'password': password},
      );
      print("success");
      return true;
    } catch (e) {
      print("faild");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Backgroundimage(
        child: SingleChildScrollView(
          child: Form(
            key: formkey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 127),
                  const LoginHeader(),
                  const SizedBox(height: 78),

                  /// Email + Password
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFiledWithAction(
                        firsticon: Icons.check,
                        secondicon: Icons.error_outline,
                        hinttext: "Email",
                        controller: emailcontroller,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                        widget: Icon(
                          Icons.check,
                          color: ischecked
                              ? AppColor.buttonBackground
                              : AppColor.subtitleColor,
                        ),
                        obscureText: false,
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
                            return "please enter a stronger password";
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

                  const SizedBox(height: 40),

                  /// Login Button
                  Loginbottom(
                    onLogin: () async {
                      print("LOGIN BUTTON PRESSED");

                      final success = await login(
                        email: "majed11@email.com",
                        password: "123456789",
                      );
                      if (success) {
                        SnackBarHelper.showSuccess(
                          context,
                          "تم تسجيل الدخول بنجاح",
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                        );
                      } else {
                        SnackBarHelper.showError(context, "فشل تسجيل الدخول");
                      }
                    },
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
