// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radiology_center_app/core/constant/app_color.dart';
import 'package:radiology_center_app/core/services/services.dart';
import 'package:radiology_center_app/views/admin_dashboard/controller/admin_cubit.dart';
import 'package:radiology_center_app/views/admin_dashboard/controller/appointments_cubit.dart';
import 'package:radiology_center_app/views/admin_dashboard/controller/devices_cubit.dart';
import 'package:radiology_center_app/views/admin_dashboard/controller/overview_cubit.dart';
import 'package:radiology_center_app/views/admin_dashboard/tabs/appointments_tab.dart';
import 'package:radiology_center_app/views/admin_dashboard/tabs/manage_accounts_tab.dart';
import 'package:radiology_center_app/views/admin_dashboard/tabs/manage_devices_tab.dart';
import 'package:radiology_center_app/views/admin_dashboard/tabs/overview_tab.dart';
import 'package:radiology_center_app/views/admin_dashboard/widgets/side_menu.dart';
import 'package:radiology_center_app/views/auth/login/login_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int selectedIndex = 0;

  final List<Widget> tabs = const [
    OverviewTab(),
    ManageAccountsTab(),
    ManageDevicesTab(),
    AppointmentsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => OverviewCubit()..fetchStats()),
        BlocProvider(create: (_) => AdminCubit()..fetchAllUsers()),
        BlocProvider(create: (_) => DevicesCubit()..fetchDevices()),
        BlocProvider(
          create: (_) => AppointmentsCubit()..fetchAllAppointments(),
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: Row(
          children: [
            // SIDE MENU
            SideMenu(
              selectedIndex: selectedIndex,
              onItemSelected: (index) async {
                if (index == -1) {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("تأكيد تسجيل الخروج"),
                      content: const Text(
                        "هل أنت متأكد أنك تريد تسجيل الخروج؟",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, false); // إلغاء
                          },
                          child: const Text(
                            "إلغاء",
                            style: TextStyle(color: AppColor.xIcon),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context, true); // تأكيد
                          },
                          child: const Text(
                            "تأكيد",
                            style: TextStyle(color: AppColor.buttonBackground),
                          ),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    // مسح كل البيانات
                    await SharedPreferencesService().removeAllData();

                    // العودة لشاشة تسجيل الدخول
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  }
                } else {
                  setState(() {
                    selectedIndex = index;
                  });
                }
              },
            ),

            // MAIN CONTENT
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(20.r),
                child: IndexedStack(index: selectedIndex, children: tabs),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
