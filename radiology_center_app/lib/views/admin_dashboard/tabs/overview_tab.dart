// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../controller/overview_cubit.dart';
import '../controller/overview_state.dart';
import '../widgets/admin_stat_card.dart';
import '../widgets/recent_appointments_list.dart';
import '../../../../core/constant/app_color.dart';
import '../../../../core/constant/text_style.dart';

class OverviewTab extends StatelessWidget {
  const OverviewTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OverviewCubit, OverviewState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.isError) {
          return Center(
            child: Text(
              "Failed to load dashboard data",
              style: AppTextStyles.textStyle16.copyWith(color: AppColor.xIcon),
            ),
          );
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(20.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -------------------------------
              // Stats Cards
              // -------------------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: AdminStatCard(
                      title: "Devices",
                      value: state.totalDevices.toString(),
                      icon: Icons.biotech_rounded,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: AdminStatCard(
                      title: "Users",
                      value: state.totalUsers.toString(),
                      icon: Icons.people_alt_rounded,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: AdminStatCard(
                      title: "Appointments",
                      value: state.totalAppointments.toString(),
                      icon: Icons.calendar_month_rounded,
                      color: Colors.orange,
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: AdminStatCard(
                      title: "Today",
                      value: state.todayAppointments.toString(),
                      icon: Icons.today_rounded,
                      color: Colors.purple,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 30.h),

              // -------------------------------
              // Recent Appointments Title
              // -------------------------------
              Text(
                "Recent Appointments",
                style: AppTextStyles.textStyle20.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColor.black,
                ),
              ),
              SizedBox(height: 15.h),

              // -------------------------------
              // Recent Appointments List
              // -------------------------------
              const RecentAppointmentsList(),
            ],
          ),
        );
      },
    );
  }
}
