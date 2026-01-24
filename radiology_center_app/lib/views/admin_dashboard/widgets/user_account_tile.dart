// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constant/app_color.dart';
import '../../../../core/constant/text_style.dart';

class UserAccountTile extends StatelessWidget {
  final String name;
  final String email;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const UserAccountTile({
    super.key,
    required this.name,
    required this.email,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColor.buttonBackground.withOpacity(0.1),
            child: const Icon(Icons.person, color: AppColor.buttonBackground),
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.textStyle16.copyWith(
                    color: AppColor.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  email,
                  style: AppTextStyles.textStyle12.copyWith(
                    color: AppColor.subtitleColor,
                  ),
                ),
              ],
            ),
          ),
          // أزرار التحكم
          IconButton(
            icon: const Icon(Icons.edit_note, color: AppColor.tosca),
            onPressed: onEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep, color: AppColor.xIcon),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
