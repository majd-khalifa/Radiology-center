// lib/views/admin_dashboard/tabs/overview_tab.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/admin_stat_card.dart';
import '../widgets/recent_appointments_list.dart';
import '../../../../core/constant/app_color.dart';
import '../../../../core/constant/text_style.dart';

class OverviewTab extends StatelessWidget {
  const OverviewTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(25.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome, Admin",
            style: AppTextStyles.textStyle28.copyWith(color: AppColor.black),
          ),
          SizedBox(height: 20.h),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            crossAxisSpacing: 20.w,
            mainAxisSpacing: 20.h,
            childAspectRatio: 1.5,
            children: const [
              AdminStatCard(
                title: "Total Patients",
                value: "1,240",
                icon: Icons.people_alt,
                color: AppColor.iconblue,
              ),
              AdminStatCard(
                title: "New Bookings",
                value: "12",
                icon: Icons.calendar_today,
                color: AppColor.urgent,
              ),
              AdminStatCard(
                title: "System Alerts",
                value: "2",
                icon: Icons.warning_amber_rounded,
                color: AppColor.xIcon,
              ),
            ],
          ),
          SizedBox(height: 30.h),
          Text(
            "Recent Activity",
            style: AppTextStyles.textStyle18.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15.h),
          const RecentAppointmentsList(),
        ],
      ),
    );
  }
}
