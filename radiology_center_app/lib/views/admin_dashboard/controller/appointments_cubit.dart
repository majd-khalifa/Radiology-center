import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radiology_center_app/core/services/api/api_services.dart';
import 'package:radiology_center_app/core/constant/constant.dart';
import 'package:radiology_center_app/models/appointment_model.dart';
import 'appointments_state.dart'; // تأكد من وجود هذا الاستيراد
import '../../../../core/services/api/api_link.dart';

class AppointmentsCubit extends Cubit<AppointmentsState> {
  final ApiServices _apiServices = ApiServices();

  AppointmentsCubit() : super(AppointmentsInitial());

  Future<void> fetchBookedAppointments() async {
    emit(AppointmentsLoading());
    try {
      final response = await _apiServices.getData(
        url: ApiLink.bookedAppointments,
        token: ConstantData.tokenValue, // التوكن مطلوب كما في بوستمان
      );

      // الدخول إلى مفتاح "data" لأن السيرفر يعيد قائمة بداخل مفتاح
      if (response != null && response['data'] != null) {
        List rawData = response['data'];

        List<AppointmentModel> appointments = rawData
            .map((e) => AppointmentModel.fromJson(e))
            .toList();

        emit(AppointmentsSuccess(appointments));
      } else {
        emit(AppointmentsSuccess([]));
      }
    } catch (e) {
      // الآن سيعمل هذا السطر لأن AppointmentsError أصبحت معرفة
      emit(AppointmentsError("Failed to fetch appointments: $e"));
    }
  }
  // أضف هذه الدوال داخل class AppointmentsCubit في ملف appointments_cubit.dart

  // 1. حذف موعد
  Future<void> cancelAppointment(int appointmentId) async {
    try {
      await _apiServices.deleteData(
        url: ApiLink.deleteAppointment(appointmentId),
        token: ConstantData.tokenValue,
      );
      fetchBookedAppointments(); // إعادة جلب المواعيد لتحديث القائمة
    } catch (e) {
      emit(AppointmentsError("فشل حذف الموعد: $e"));
    }
  }

  // 2. تعديل موعد (مثلاً تغيير الوقت أو التاريخ)
  Future<void> updateAppointment(
    int appointmentId,
    Map<String, dynamic> newData,
  ) async {
    try {
      await _apiServices.putData(
        url: ApiLink.updateAppointment(appointmentId),
        body: newData,
        token: ConstantData.tokenValue,
      );
      fetchBookedAppointments();
    } catch (e) {
      emit(AppointmentsError("فشل تعديل الموعد: $e"));
    }
  }
}
