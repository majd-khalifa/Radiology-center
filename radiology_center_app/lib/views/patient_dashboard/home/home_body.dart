import 'package:flutter/material.dart';
import 'package:radiology_center_app/core/constant/app_color.dart';
import 'package:radiology_center_app/core/constant/text_style.dart';
import 'package:radiology_center_app/views/patient_dashboard/home/widgets/category_item.dart';
import 'package:radiology_center_app/views/patient_dashboard/appointment/appointment_screen.dart';
import 'package:radiology_center_app/core/services/api/api_services.dart';
import 'package:radiology_center_app/core/constant/constant.dart';
import 'package:radiology_center_app/models/my_appointment_model.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(23),
            topRight: Radius.circular(23),
          ),
        ),
        child: Column(
          children: [
            ServicesSection(),
            SizedBox(height: 19),
            AppointmentSection(),
          ],
        ),
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
        Padding(
          padding: const EdgeInsets.all(20),
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
                      builder: (_) => AppointmentScreen(deviceId: 1),
                    ),
                  );
                },
                child: const CategoryItem(
                  "X-Ray",
                  'assets/icons/consultation.svg',
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AppointmentScreen(deviceId: 2),
                    ),
                  );
                },
                child: const CategoryItem("CTI", 'assets/icons/medicines.svg'),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AppointmentScreen(deviceId: 3),
                    ),
                  );
                },
                child: const CategoryItem("MRI", 'assets/icons/ambulance.svg'),
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

    final data = await api.getData(
      url: "http://10.0.2.2:8000/api/radiology/my-appointments/",
      token: token,
    );

    return (data as List).map((e) => MyAppointmentModel.fromJson(e)).toList();
  }

  Future<void> deleteAppointment(int id) async {
    final api = ApiServices();
    final token = ConstantData.tokenValue;

    try {
      await api.deleteData(
        url: "http://10.0.2.2:8000/api/radiology/appointments/$id/delete/",
        token: token,
      );

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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Appointment",
                style: AppTextStyles.textStyle16.copyWith(
                  color: AppColor.black,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 255, // ارتفاع مناسب داخل الصفحة
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
                padding: const EdgeInsets.only(bottom: 12),
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
                          : Colors.red.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      appt.isAvailable ? "Available" : "Booked",
                      style: TextStyle(
                        color: appt.isAvailable ? Colors.green : Colors.red,
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
