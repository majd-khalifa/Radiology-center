import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:radiology_center_app/core/constant/app_color.dart';
import 'package:radiology_center_app/core/constant/constant.dart';
import 'package:radiology_center_app/core/constant/text_style.dart';
import 'package:radiology_center_app/core/constant/app_route.dart';
import 'package:radiology_center_app/core/services/api/api_link.dart';
import 'package:radiology_center_app/core/services/api/api_services.dart';

class DashboardHeader extends StatefulWidget {
  const DashboardHeader({super.key});

  @override
  State<DashboardHeader> createState() => _DashboardHeaderState();
}

class _DashboardHeaderState extends State<DashboardHeader> {
  String userName = "User";
  String? profileImage;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final api = ApiServices();
    final token = ConstantData.tokenValue;

    final profile = await api.getProfile(token);

    setState(() {
      userName = profile["full_name"] ?? "User";

      final img = profile["profile_image"];
      profileImage = img != null ? "${ApiLink.baseUrl}$img" : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // LEFT SIDE
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Welcome!", style: AppTextStyles.textStyle32),
                Text(userName, style: AppTextStyles.textStyle32),
                SizedBox(height: 4.h),
                Text(
                  "How is it going today?",
                  style: AppTextStyles.textStyle16,
                ),
                SizedBox(height: 24.h),

                SizedBox(
                  width: 141.w,
                  height: 48.h,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoute.aiAnalysis);
                    },
                    icon: SvgPicture.asset(
                      'assets/icons/urgent.svg',
                      width: 20.w,
                      height: 20.h,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    label: Text(
                      'AI Analysis',
                      style: AppTextStyles.textStyle14.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.urgent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.r),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                    ),
                  ),
                ),

                SizedBox(height: 30.h),
              ],
            ),
          ),

          SizedBox(width: 16.w),

          // RIGHT SIDE (PROFILE IMAGE)
          Image.asset(
            'assets/images/doctor4.png',

            width: 188.w,
            height: 260.h,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
