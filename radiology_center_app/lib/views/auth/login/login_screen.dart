// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:radiology_center_app/core/constant/app_color.dart';
import 'package:radiology_center_app/core/services/auth_service.dart';
import 'package:radiology_center_app/views/auth/login/login_header.dart';
import 'package:radiology_center_app/views/auth/login/loginbottom.dart';
import 'package:radiology_center_app/views/auth/widgets/text_filed_with_action.dart';
import 'package:radiology_center_app/core/widgets/background_image.dart';

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

  final AuthService _authService = AuthService();

  void _printToken() async {
    final token = await _authService.getAccessToken();
    print("ACCESS TOKEN = $token");
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
                      // Debug

                      if (formkey.currentState!.validate()) {
                        final success = await _authService.login(
                          username: emailcontroller.text.trim(),
                          password: passwordcontroller.text.trim(),
                        );
                        print("LOGIN RESULT = $success");

                        if (success) {
                          _printToken();

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Login successful")),
                          );

                          Navigator.pushReplacementNamed(context, "/home");
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Invalid email or password"),
                            ),
                          );
                        }
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
