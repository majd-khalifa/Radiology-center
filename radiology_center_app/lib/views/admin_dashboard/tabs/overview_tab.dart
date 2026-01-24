import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radiology_center_app/views/admin_dashboard/controller/overview_cubit.dart';
import '../../../../core/constant/app_color.dart';

class OverviewTab extends StatelessWidget {
  const OverviewTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OverviewCubit()..fetchStats(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BlocBuilder<OverviewCubit, OverviewState>(
          builder: (context, state) {
            if (state.isLoading)
              return const Center(child: CircularProgressIndicator());
            return Padding(
              padding: const EdgeInsets.all(25.0),
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: [
                  _buildStatCard(
                    "الأجهزة",
                    state.totalDevices.toString(),
                    Icons.biotech,
                    Colors.blue,
                  ),
                  _buildStatCard(
                    "المواعيد المحجوزة",
                    state.totalAppointments.toString(),
                    Icons.event_available,
                    Colors.green,
                  ),
                  _buildStatCard(
                    "المستخدمين",
                    state.totalUsers.toString(),
                    Icons.people,
                    Colors.orange,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 50, color: color),
          const SizedBox(height: 15),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
