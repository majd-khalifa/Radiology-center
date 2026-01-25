import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:radiology_center_app/core/constant/app_color.dart';
import 'package:radiology_center_app/core/constant/constant.dart';
import 'package:radiology_center_app/core/enums/user_role.dart';
import 'package:radiology_center_app/core/helper/snack_bar_helper.dart';
import 'package:radiology_center_app/core/services/api/api_link.dart';
import 'package:radiology_center_app/core/services/api/api_services.dart';
import 'package:radiology_center_app/core/services/services.dart';
import 'package:radiology_center_app/core/widgets/background_image.dart';
import 'package:radiology_center_app/core/widgets/green_button.dart';
import 'package:radiology_center_app/models/user_model.dart';
import 'package:radiology_center_app/views/admin_dashboard/admin_dashboard_screen.dart';
import 'package:radiology_center_app/views/auth/login/login_header.dart';
import 'package:radiology_center_app/views/auth/signup/signup_body.dart';
import 'package:radiology_center_app/views/auth/widgets/text_filed_with_action.dart';
import 'package:radiology_center_app/views/patient_dashboard/home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final ApiServices api = ApiServices();
  final SharedPreferencesService prefs = SharedPreferencesService();

  bool obscureText = true;
  bool isLoading = false;
  bool isChecked = false; // لتحديث أيقونة البريد

  Future<UserRole?> login() async {
    setState(() => isLoading = true);
    try {
      // ignore: unused_local_variable
      final response = await api.postData(
        url: ApiLink.login,
        body: {
          "email": emailController.text,
          "password": passwordController.text,
        },
      );

      final data = response['data'];
      final token = data['token'];
      final userJson = data['user'];
      final user = UserModel.fromJson(userJson);

      // حفظ البيانات
      await prefs.saveStringValue("user_name", user.username);
      await prefs.saveStringValue("user_id", user.id.toString());
      await prefs.saveUserEmail(user.email);
      await prefs.saveTokenUser(token);

      ConstantData.tokenValue = token;
      ConstantData.idValue = user.id.toString();

      return user.role;
    } catch (_) {
      SnackBarHelper.showError(context, "Invalid email or password");
      return null;
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Backgroundimage(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 127),
                  const LoginHeader(),
                  const SizedBox(height: 78),

                  // Email + Password
                  TextFiledWithAction(
                    firsticon: Icons.check,
                    secondicon: Icons.error_outline,
                    hinttext: "Email",
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                    widget: Icon(
                      Icons.check,
                      color: isChecked
                          ? AppColor.buttonBackground
                          : AppColor.subtitleColor,
                    ),
                    obscureText: false,
                    onChanged: (value) {
                      setState(() {
                        isChecked = value.contains("@") && value.contains(".");
                      });
                    },
                  ),
                  const SizedBox(height: 18),
                  TextFiledWithAction(
                    hinttext: "● ● ● ● ● ●",
                    controller: passwordController,
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
                        setState(() => obscureText = !obscureText);
                      },
                      icon: Icon(
                        obscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                    obscureText: obscureText,
                  ),

                  const SizedBox(height: 40),

                  // Login Button
                  GreenButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                            if (!formKey.currentState!.validate()) return;

                            final role = await login();
                            if (role != null) {
                              // تحقق البريد تلقائيًا إذا كان يحتوي "@"
                              setState(() {
                                isChecked = emailController.text.contains("@");
                              });

                              SnackBarHelper.showSuccess(
                                context,
                                "Login successfully",
                              );

                              switch (role) {
                                case UserRole.user:
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const HomeScreen(),
                                    ),
                                  );
                                  break;
                                case UserRole.admin:
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const AdminDashboardScreen(),
                                    ),
                                  );
                                  break;
                              }
                            }
                          },
                    widget: isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            "Login",
                            style: TextStyle(color: Colors.white),
                          ),
                  ),

                  const SizedBox(height: 40),

                  // Signup Link
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Don’t have an account?",
                        style: TextStyle(
                          color: AppColor.buttonBackground,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: " Sign up",
                            style: const TextStyle(
                              color: AppColor.buttonBackground,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const SignupScreen(),
                                  ),
                                );
                              },
                          ),
                        ],
                      ),
                    ),
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
