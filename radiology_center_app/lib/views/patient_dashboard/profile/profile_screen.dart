// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radiology_center_app/core/constant/app_color.dart';
import 'package:radiology_center_app/core/constant/app_route.dart';
import 'package:radiology_center_app/core/constant/text_style.dart';
import 'package:radiology_center_app/core/widgets/green_button.dart';
import 'package:radiology_center_app/core/widgets/text_form_field.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // الخلفية الخضراء العلوية
          Container(
            height: 350.h,
            decoration: BoxDecoration(
              color: AppColor.buttonBackground,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30.r),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildModifiedAppBar(context, "Profile"),

                  SizedBox(height: 20.h),
                  Text(
                    "Set up your profile",
                    style: AppTextStyles.textStyle18.copyWith(
                      color: AppColor.white,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: Text(
                      "Update your profile to connect your doctor with better impression.",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.textStyle14.copyWith(
                        color: AppColor.white.withOpacity(0.8),
                      ),
                    ),
                  ),

                  SizedBox(height: 30.h),
                  _buildProfileImage(),
                  SizedBox(height: 40.h),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Personal information",
                          style: AppTextStyles.textStyle18.copyWith(
                            color: AppColor.black,
                          ),
                        ),
                        SizedBox(height: 10.h),

                        // استخدام الويدجيت المشتركة الجديدة
                        const CustomTextFormField(
                          label: "Name",
                          hintText: "Abdullah Mamun",
                        ),
                        const CustomTextFormField(
                          label: "Contact Number",
                          hintText: "+8801800000000",
                          hasEditIcon: true,
                          keyboardType: TextInputType.phone,
                        ),
                        const CustomTextFormField(
                          label: "Date of birth",
                          hintText: "DD MM YYYY",
                          hasEditIcon: true,
                        ),
                        const CustomTextFormField(
                          label: "Location",
                          hintText: "Add Details",
                        ),

                        SizedBox(height: 40.h),

                        GreenButton(
                          onPressed: () {},
                          widget: Text(
                            "Continue",
                            style: AppTextStyles.textStyle18.copyWith(
                              color: AppColor.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 30.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // (ويدجيت اختيار الصورة والـ AppBar تبقى كما هي أو تنقل لملفات مستقلة أيضاً)
  Widget _buildProfileImage() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 65.r,
          backgroundColor: AppColor.silver,
          backgroundImage: const AssetImage('assets/images/profile_ali.jpg'),
        ),
        CircleAvatar(
          radius: 18.r,
          backgroundColor: AppColor.subtitleColor,
          child: Icon(Icons.camera_alt, color: AppColor.white, size: 18.r),
        ),
      ],
    );
  }

  Widget _buildModifiedAppBar(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context, AppRoute.home),
            child: Container(
              width: 30.w,
              height: 30.h,
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                size: 15.sp,
                color: AppColor.grey,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Text(
            title,
            style: AppTextStyles.textStyle18.copyWith(color: AppColor.white),
          ),
        ],
      ),
    );
  }
}
