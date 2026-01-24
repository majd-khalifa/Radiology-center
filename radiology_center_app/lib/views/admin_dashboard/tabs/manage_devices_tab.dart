import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constant/app_color.dart';
import '../../../../core/constant/text_style.dart';
import '../widgets/user_account_tile.dart';

class ManageAccountsTab extends StatelessWidget {
  const ManageAccountsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),
          Text(
            "Account Management",
            style: AppTextStyles.textStyle24.copyWith(
              color: AppColor.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Search, edit or remove user accounts",
            style: AppTextStyles.textStyle14.copyWith(
              color: AppColor.subtitleColor,
            ),
          ),
          SizedBox(height: 20.h),

          // قائمة الحسابات (UI تجريبي)
          Expanded(
            child: ListView.builder(
              itemCount: 8,
              itemBuilder: (context, index) {
                return UserAccountTile(
                  name: "User Full Name $index",
                  email: "user.email$index@example.com",
                  onEdit: () => print("Edit User $index"),
                  onDelete: () => _showDeleteDialog(context),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ديالوج تأكيد الحذف
  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Delete", style: AppTextStyles.textStyle18),
        content: Text(
          "Are you sure you want to delete this account?",
          style: AppTextStyles.textStyle14,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Delete",
              style: TextStyle(color: AppColor.xIcon),
            ),
          ),
        ],
      ),
    );
  }
}
