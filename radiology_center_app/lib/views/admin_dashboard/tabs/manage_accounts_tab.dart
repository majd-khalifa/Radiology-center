// lib/views/admin_dashboard/tabs/manage_accounts_tab.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constant/app_color.dart';
import '../../../../core/constant/text_style.dart';
import '../widgets/user_account_tile.dart';

class ManageAccountsTab extends StatelessWidget {
  const ManageAccountsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(25.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "User Accounts",
                style: AppTextStyles.textStyle24.copyWith(
                  color: AppColor.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.buttonBackground,
                ),
                onPressed: () {},
                icon: const Icon(Icons.add, color: AppColor.white),
                label: Text(
                  "Add Admin",
                  style: TextStyle(color: AppColor.white),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) => UserAccountTile(
                name: "Username $index",
                email: "user$index@radiology.com",
                onEdit: () {},
                onDelete: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
