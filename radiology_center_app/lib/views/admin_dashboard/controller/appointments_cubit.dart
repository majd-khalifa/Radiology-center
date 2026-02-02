import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radiology_center_app/core/services/api/api_services.dart';
import 'package:radiology_center_app/core/constant/constant.dart';
import 'package:radiology_center_app/models/appointment_model.dart';
import 'appointments_state.dart';
import '../../../../core/services/api/api_link.dart';

class AppointmentsCubit extends Cubit<AppointmentsState> {
  final ApiServices _apiServices = ApiServices();

  AppointmentsCubit() : super(AppointmentsInitial());

  // ============================================================
  // 1) جلب كل المواعيد
  // ============================================================
  Future<void> fetchAllAppointments() async {
    emit(AppointmentsLoading());
    try {
      final response = await _apiServices.getData(
        url: ApiLink.bookedAppointments,
        token: ConstantData.tokenValue,
      );

      List<AppointmentModel> appointments = (response["data"] as List)
          .map((e) => AppointmentModel.fromJson(e))
          .toList();

      emit(AppointmentsLoadSuccess(appointments));
    } catch (e) {
      emit(AppointmentsError("فشل جلب المواعيد: $e"));
    }
  }

  // ============================================================
  // 2) إنشاء موعد جديد (بدون إعادة تحميل ثقيل)
  // ============================================================
  Future<void> createAppointment(Map<String, dynamic> data) async {
    final currentState = state;
    if (currentState is! AppointmentsLoadSuccess) return;

    emit(AppointmentOperationLoading());
    try {
      final created = await _apiServices.postData(
        url: ApiLink.adminCreateAppointment,
        body: data,
        token: ConstantData.tokenValue,
      );

      final newAppt = AppointmentModel.fromJson(created);

      final updatedList = [...currentState.appointments, newAppt];

      emit(AppointmentsLoadSuccess(updatedList));
    } catch (e) {
      emit(AppointmentsError("فشل إنشاء الموعد: $e"));
    }
  }

  // ============================================================
  // 3) تعديل موعد (بدون fetchAllAppointments)
  // ============================================================
  Future<void> updateAppointment(int id, Map<String, dynamic> data) async {
    final currentState = state;
    if (currentState is! AppointmentsLoadSuccess) return;

    emit(AppointmentOperationLoading());
    try {
      await _apiServices.putData(
        url: ApiLink.adminUpdateAppointment(id),
        body: data,
        token: ConstantData.tokenValue,
      );

      final updatedList = currentState.appointments.map((appt) {
        if (appt.id == id) {
          return appt.copyWith(
            date: data["date"],
            time: data["time"],
            bookedByName: data["booked_by_name"],
            bookedByEmail: data["booked_by_email"],
          );
        }
        return appt;
      }).toList();

      emit(AppointmentsLoadSuccess(updatedList));
    } on DioError catch (e) {
      if (e.response?.statusCode == 400) {
        emit(
          AppointmentsError(
            e.response?.data['error'] ?? "Time slot unavailable",
          ),
        );
      } else {
        emit(AppointmentsError("فشل تعديل الموعد: ${e.message}"));
      }
    }
  }

  // ============================================================
  // 4) حذف موعد (بدون fetchAllAppointments)
  // ============================================================
  Future<void> deleteAppointment(int id, String date) async {
    final currentState = state;
    if (currentState is! AppointmentsLoadSuccess) return;

    emit(AppointmentOperationLoading());
    try {
      await _apiServices.deleteData(
        url: ApiLink.adminDeleteAppointment(id),
        body: {"date": date},
        token: ConstantData.tokenValue,
      );

      final updatedList = currentState.appointments
          .where((appt) => appt.id != id)
          .toList();

      emit(AppointmentsLoadSuccess(updatedList));
    } catch (e) {
      emit(AppointmentsError("فشل حذف الموعد: $e"));
    }
  }
}
