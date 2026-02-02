// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radiology_center_app/models/appointment_model.dart';

import '../controller/appointments_cubit.dart';
import '../controller/appointments_state.dart';
import '../../../../core/constant/app_color.dart';
import '../../../../core/constant/text_style.dart';

class AppointmentsTab extends StatelessWidget {
  const AppointmentsTab({super.key});

  void showAddAppointmentDialog(BuildContext context) {
    final appointmentsCubit = context.read<AppointmentsCubit>();

    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final dateController = TextEditingController();
    final timeController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            "Add Appointment",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Booked By (Name)",
                  ),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "Booked By (Email)",
                  ),
                ),
                TextField(
                  controller: dateController,
                  readOnly: true,
                  decoration: const InputDecoration(labelText: "Date"),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: dialogContext,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) {
                      dateController.text = picked.toIso8601String().split(
                        "T",
                      )[0];
                    }
                  },
                ),
                TextField(
                  controller: timeController,
                  readOnly: true,
                  decoration: const InputDecoration(labelText: "Time"),
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: dialogContext,
                      initialTime: TimeOfDay.now(),
                    );
                    if (picked != null) {
                      timeController.text =
                          "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final data = {
                  "date": dateController.text,
                  "time": timeController.text,
                  "booked_by_name": nameController.text,
                  "booked_by_email": emailController.text,
                };

                appointmentsCubit.createAppointment(data);
                Navigator.pop(dialogContext);
              },
              child: const Text("Create"),
            ),
          ],
        );
      },
    );
  }

  void showEditAppointmentDialog(BuildContext context, AppointmentModel appt) {
    final appointmentsCubit = context.read<AppointmentsCubit>();

    final nameController = TextEditingController(text: appt.bookedByName);
    final emailController = TextEditingController(text: appt.bookedByEmail);
    final dateController = TextEditingController(text: appt.date);
    final timeController = TextEditingController(text: appt.time);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            "Edit Appointment",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Booked By (Name)",
                  ),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "Booked By (Email)",
                  ),
                ),
                TextField(
                  controller: dateController,
                  readOnly: true,
                  decoration: const InputDecoration(labelText: "Date"),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: dialogContext,
                      initialDate:
                          DateTime.tryParse(appt.date) ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) {
                      dateController.text = picked.toIso8601String().split(
                        "T",
                      )[0];
                    }
                  },
                ),
                TextField(
                  controller: timeController,
                  readOnly: true,
                  decoration: const InputDecoration(labelText: "Time"),
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: dialogContext,
                      initialTime: TimeOfDay(
                        hour: int.parse(appt.time.split(":")[0]),
                        minute: int.parse(appt.time.split(":")[1]),
                      ),
                    );
                    if (picked != null) {
                      timeController.text =
                          "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final updatedData = {
                  "date": dateController.text,
                  "time": timeController.text,
                  "booked_by_name": nameController.text,
                  "booked_by_email": emailController.text,
                };

                appointmentsCubit.updateAppointment(appt.id, updatedData);

                Navigator.pop(dialogContext);
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentsCubit, AppointmentsState>(
      builder: (context, state) {
        if (state is AppointmentsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is AppointmentsError) {
          return Center(
            child: Text(
              state.message,
              style: AppTextStyles.textStyle16.copyWith(color: AppColor.xIcon),
            ),
          );
        }

        if (state is AppointmentsLoadSuccess ||
            state is AppointmentOperationSuccess) {
          final appointments = state is AppointmentsLoadSuccess
              ? state.appointments
              : (state as AppointmentOperationSuccess).appointments;

          return SingleChildScrollView(
            padding: EdgeInsets.all(20.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Manage Appointments",
                  style: AppTextStyles.textStyle20.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColor.black,
                  ),
                ),
                SizedBox(height: 20.h),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: appointments.length,
                  itemBuilder: (context, index) {
                    final appt = appointments[index];

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
                            backgroundColor: AppColor.buttonBackground
                                .withOpacity(0.1),
                            child: const Icon(
                              Icons.calendar_month_rounded,
                              color: AppColor.buttonBackground,
                            ),
                          ),
                          SizedBox(width: 15.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  appt.bookedByName,
                                  style: AppTextStyles.textStyle16.copyWith(
                                    color: AppColor.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "${appt.bookedByEmail} • ${appt.date} at ${appt.time}",
                                  style: AppTextStyles.textStyle12.copyWith(
                                    color: AppColor.subtitleColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.edit_note,
                              color: AppColor.tosca,
                            ),
                            onPressed: () {
                              showEditAppointmentDialog(context, appt);
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete_sweep,
                              color: AppColor.xIcon,
                            ),
                            onPressed: () {
                              context
                                  .read<AppointmentsCubit>()
                                  .deleteAppointment(appt.id, appt.date);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}
