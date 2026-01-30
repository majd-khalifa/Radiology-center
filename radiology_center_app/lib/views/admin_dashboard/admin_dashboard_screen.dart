// ignore_for_file: deprecated_member_use, avoid_print

import 'package:flutter/material.dart';
import 'package:radiology_center_app/core/constant/app_color.dart';
import 'package:radiology_center_app/core/services/services.dart';
import 'package:radiology_center_app/views/admin_dashboard/tabs/overview_tab.dart';
import 'package:radiology_center_app/views/admin_dashboard/widgets/side_menu.dart';
import 'package:radiology_center_app/views/admin_dashboard/tabs/manage_accounts_tab.dart';
import 'package:radiology_center_app/views/admin_dashboard/tabs/appointments_tab.dart';

// 1. أضف الـ Import الخاص بتابة الأجهزة الجديدة
import 'package:radiology_center_app/views/admin_dashboard/tabs/manage_devices_tab.dart';
import 'package:radiology_center_app/views/auth/login/login_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;

  // 2. تحديث قائمة الـ Tabs لاستبدال النصوص الثابتة بالكلاسات الفعلية
  final List<Widget> _tabs = [
    OverviewTab(),
    ManageAccountsTab(),
    ManageDevicesTab(), // تم استبدال النص الثابت بالكلاس الجديد للأجهزة
    AppointmentsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.silver.withOpacity(0.3),
      body: Row(
        children: [
          SideMenu(
            selectedIndex: _selectedIndex,
            onItemSelected: (index) async {
              if (index == -1) {
                // مسح كل البيانات
                await SharedPreferencesService().removeAllData();

                // العودة لشاشة تسجيل الدخول
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              } else {
                setState(() {
                  _selectedIndex = index;
                });
              }
            },
          ),
          VerticalDivider(width: 1, color: AppColor.silver),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Container(
                key: ValueKey<int>(_selectedIndex),
                child: _tabs[_selectedIndex],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
