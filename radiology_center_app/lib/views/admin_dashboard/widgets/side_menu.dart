import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radiology_center_app/core/constant/app_color.dart';
import 'package:radiology_center_app/core/constant/text_style.dart';

class SideMenu extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const SideMenu({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180.w,
      color: AppColor.white,
      child: Column(
        children: [
          // رأس القائمة - Logo أو عنوان
          Container(
            height: 150.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColor.silver, width: 1),
              ),
            ),
            child: Text(
              "Radiology Admin",
              style: AppTextStyles.textStyle20.copyWith(
                color: AppColor.buttonBackground,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 20.h),

          // عناصر القائمة
          _buildMenuItem(Icons.grid_view_rounded, "Overview", 0),
          _buildMenuItem(Icons.manage_accounts_rounded, "Accounts", 1),
          _buildMenuItem(Icons.biotech_rounded, "Devices", 2),
          _buildMenuItem(Icons.calendar_month_rounded, "Appointments", 3),

          const Spacer(),

          // زر تسجيل الخروج
          _buildMenuItem(Icons.logout_rounded, "Logout", -1, isLogout: true),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title,
    int index, {
    bool isLogout = false,
  }) {
    bool isSelected = selectedIndex == index;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 4.h),
      child: ListTile(
        onTap: () => onItemSelected(index),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        selected: isSelected,
        selectedTileColor: AppColor.buttonBackground.withOpacity(0.1),
        leading: Icon(
          icon,
          color: isLogout
              ? AppColor.xIcon
              : (isSelected ? AppColor.buttonBackground : AppColor.grey),
        ),
        title: Text(
          title,
          style: AppTextStyles.textStyle16.copyWith(
            color: isLogout
                ? AppColor.xIcon
                : (isSelected ? AppColor.buttonBackground : AppColor.black),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
