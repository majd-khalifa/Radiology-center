import 'package:flutter/material.dart';
import 'package:radiology_center_app/core/constant/app_color.dart';
import 'package:radiology_center_app/views/admin_dashboard/widgets/side_menu.dart';
import 'package:radiology_center_app/views/admin_dashboard/tabs/manage_accounts_tab.dart';
// تأكد من عمل Import لباقي الـ Tabs عند إنشائها

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;

  // المحتويات (Tabs)
  final List<Widget> _tabs = [
    const Center(child: Text("Overview Content")), // سنقوم ببرمجتها لاحقاً
    const ManageAccountsTab(), // التي برمجناها في الرد السابق
    const Center(child: Text("Manage Devices Content")),
    const Center(child: Text("Appointments Content")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.silver.withOpacity(
        0.3,
      ), // خلفية خفيفة لتمييز الـ Content
      body: Row(
        children: [
          // 1. القائمة الجانبية ثابتة في اليسار
          SideMenu(
            selectedIndex: _selectedIndex,
            onItemSelected: (index) {
              if (index == -1) {
                // منطق تسجيل الخروج هنا
                print("Logout clicked");
              } else {
                setState(() {
                  _selectedIndex = index;
                });
              }
            },
          ),

          // 2. فاصل بصري بسيط
          VerticalDivider(width: 1, color: AppColor.silver),

          // 3. منطقة المحتوى المتغير
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _tabs[_selectedIndex],
            ),
          ),
        ],
      ),
    );
  }
}
