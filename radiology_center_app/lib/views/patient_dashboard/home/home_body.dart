// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radiology_center_app/core/constant/app_color.dart';
import 'package:radiology_center_app/core/constant/text_style.dart';
import 'package:radiology_center_app/core/services/api/api_link.dart';
import 'package:radiology_center_app/views/patient_dashboard/home/widgets/category_item.dart';
import 'package:radiology_center_app/views/patient_dashboard/appointment/appointment_screen.dart';
import 'package:radiology_center_app/core/constant/constant.dart';
import 'package:radiology_center_app/core/services/api/api_services.dart';
import 'package:radiology_center_app/models/my_appointment_model.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  // مفتاح للتحكم بـ AppointmentSection
  final GlobalKey<_AppointmentSectionState> appointmentKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(23.r),
          topRight: Radius.circular(23.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              "Our Services",
              style: AppTextStyles.textStyle16.copyWith(color: AppColor.black),
            ),
          ),

          SizedBox(height: 16.h),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AppointmentScreen(deviceId: 5),
                      ),
                    );
                    if (result == true) {
                      appointmentKey.currentState?.refreshAppointments();
                    }
                  },
                  child: const CategoryItem(
                    "X-Ray",
                    'assets/icons/skeleton.svg',
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AppointmentScreen(deviceId: 6),
                      ),
                    );
                    if (result == true) {
                      appointmentKey.currentState?.refreshAppointments();
                    }
                  },
                  child: const CategoryItem(
                    "UltraSound",
                    'assets/icons/ultrasound.svg',
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AppointmentScreen(deviceId: 13),
                      ),
                    );
                    if (result == true) {
                      appointmentKey.currentState?.refreshAppointments();
                    }
                  },
                  child: const CategoryItem("MRI", 'assets/icons/mri.svg'),
                ),
              ],
            ),
          ),

          SizedBox(height: 20.h),

          Expanded(child: AppointmentSection(key: appointmentKey)),
        ],
      ),
    );
  }
}

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            "Our Services",
            style: AppTextStyles.textStyle16.copyWith(color: AppColor.black),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AppointmentScreen(deviceId: 5),
                    ),
                  );
                },
                child: const CategoryItem("X-Ray", 'assets/icons/skeleton.svg'),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AppointmentScreen(deviceId: 6),
                    ),
                  );
                },
                child: const CategoryItem(
                  "UltraSound",
                  'assets/icons/ultrasound.svg',
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AppointmentScreen(deviceId: 13),
                    ),
                  );
                },
                child: const CategoryItem("MRI", 'assets/icons/mri.svg'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AppointmentSection extends StatefulWidget {
  const AppointmentSection({super.key});

  @override
  State<AppointmentSection> createState() => _AppointmentSectionState();
}

class _AppointmentSectionState extends State<AppointmentSection> {
  late Future<List<MyAppointmentModel>> _appointmentsFuture;

  @override
  void initState() {
    super.initState();
    _appointmentsFuture = fetchUserAppointments();
  }

  Future<List<MyAppointmentModel>> fetchUserAppointments() async {
    final api = ApiServices();
    final token = ConstantData.tokenValue;

    final data = await api.getData(url: ApiLink.myAppointments, token: token);

    return (data as List).map((e) => MyAppointmentModel.fromJson(e)).toList();
  }

  // ✨ دالة جديدة لتحديث المواعيد
  void refreshAppointments() {
    setState(() {
      _appointmentsFuture = fetchUserAppointments();
    });
  }

  Future<void> deleteAppointment(int id) async {
    final api = ApiServices();
    final token = ConstantData.tokenValue;

    try {
      await api.deleteData(url: ApiLink.deleteAppointment(id), token: token);

      setState(() {
        _appointmentsFuture = fetchUserAppointments();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Appointment deleted successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to delete appointment")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Appointments",
                  style: AppTextStyles.textStyle16.copyWith(
                    color: AppColor.black,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: FutureBuilder<List<MyAppointmentModel>>(
              future: _appointmentsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      "Error loading appointments",
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No appointments found"));
                }

                return ListView.builder(
                  padding: EdgeInsets.only(bottom: 12.h),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final appt = snapshot.data![index];
                    return AppointmentCard(
                      appt: appt,
                      onDelete: deleteAppointment,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AppointmentCard extends StatelessWidget {
  final MyAppointmentModel appt;
  final Function(int id) onDelete;

  const AppointmentCard({
    super.key,
    required this.appt,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon Box
            Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                color: AppColor.silver.withOpacity(0.3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.calendar_month_rounded,
                size: 36,
                color: Colors.black54,
              ),
            ),

            const SizedBox(width: 16),

            // Appointment Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date & Time
                  Text(
                    "${appt.date}  •  ${appt.time}",
                    style: AppTextStyles.textStyle16.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Status
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: appt.isAvailable
                          ? Colors.green.withOpacity(0.15)
                          : Colors.green.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      appt.isAvailable ? "Available" : "Booked",
                      style: TextStyle(
                        color: appt.isAvailable ? Colors.green : Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Divider
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: Colors.grey.shade300,
                  ),

                  const SizedBox(height: 10),

                  // Action Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Radiology Center",
                        style: AppTextStyles.textStyle12.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),

                      // زر الحذف
                      GestureDetector(
                        onTap: () => onDelete(appt.id),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "Delete",
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
