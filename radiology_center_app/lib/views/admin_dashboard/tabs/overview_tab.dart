// lib/views/admin_dashboard/tabs/overview_tab.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controller/dashboard_cubit.dart';
import '../widgets/admin_stat_card.dart';
import '../../../../core/constant/app_color.dart';

class OverviewTab extends StatelessWidget {
  const OverviewTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardCubit()..fetchStats(),
      child: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading)
            return const Center(child: CircularProgressIndicator());

          int users = (state is DashboardSuccess) ? state.usersCount : 0;
          int devices = (state is DashboardSuccess) ? state.devicesCount : 0;

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AdminStatCard(
                        title: "Users",
                        value: "$users",
                        icon: Icons.people,
                        color: AppColor.iconblue,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: AdminStatCard(
                        title: "Devices",
                        value: "$devices",
                        icon: Icons.biotech,
                        color: AppColor.buttonBackground,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // هنا منضيف الـ RecentAppointmentsList
              ],
            ),
          );
        },
      ),
    );
  }
}
