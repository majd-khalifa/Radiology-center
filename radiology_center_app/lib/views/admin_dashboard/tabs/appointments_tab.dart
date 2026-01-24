// lib/views/admin_dashboard/tabs/appointments_tab.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controller/appointments_cubit.dart';
import '../controller/appointments_state.dart';
import '../../../../core/constant/app_color.dart';
import '../../../../core/constant/text_style.dart';

class AppointmentsTab extends StatelessWidget {
  const AppointmentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // إنشاء الـ Cubit وجلب البيانات عند الدخول للتبويب
      create: (context) => AppointmentsCubit()..fetchBookedAppointments(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BlocBuilder<AppointmentsCubit, AppointmentsState>(
          builder: (context, state) {
            if (state is AppointmentsLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColor.buttonBackground,
                ),
              );
            } else if (state is AppointmentsSuccess) {
              if (state.appointments.isEmpty) {
                return const Center(
                  child: Text("لا توجد مواعيد محجوزة حالياً"),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: state.appointments.length,
                itemBuilder: (context, index) {
                  final appointment = state.appointments[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColor.buttonBackground.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.calendar_today,
                          color: AppColor.buttonBackground,
                        ),
                      ),
                      title: Text(
                        "المريض: ${appointment.bookedByName}",
                        style: AppTextStyles.textStyle16.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          Text(
                            "📧 $appointment.bookedByEmail",
                          ), // إضافة الإيميل من الموديل
                          Text("📅 التاريخ: ${appointment.date}"),
                          Text("⏰ الوقت: ${appointment.time}"),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete_sweep_rounded, // أيقونة حذف احترافية
                          color: AppColor.xIcon,
                        ),
                        // تم التعديل هنا لاستخدام appointmentId بدلاً من id
                        onPressed: () =>
                            _confirmCancel(context, appointment.appointmentId),
                      ),
                    ),
                  );
                },
              );
            } else if (state is AppointmentsError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 40,
                    ),
                    const SizedBox(height: 10),
                    Text(state.message, textAlign: TextAlign.center),
                    TextButton(
                      onPressed: () => context
                          .read<AppointmentsCubit>()
                          .fetchBookedAppointments(),
                      child: const Text("إعادة المحاولة"),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  // نافذة تأكيد الإلغاء للأدمن
  void _confirmCancel(BuildContext context, int appointmentId) {
    final cubit = context.read<AppointmentsCubit>();

    showDialog(
      context: context,
      builder: (dContext) => AlertDialog(
        title: const Text("إلغاء الموعد"),
        content: const Text("هل أنت متأكد من حذف هذا الحجز نهائياً من النظام؟"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dContext),
            child: const Text("تراجع"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              cubit.cancelAppointment(appointmentId);
              Navigator.pop(dContext);
            },
            child: const Text(
              "تأكيد الحذف",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
