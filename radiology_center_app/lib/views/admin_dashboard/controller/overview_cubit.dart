// ignore_for_file: avoid_print

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radiology_center_app/core/constant/constant.dart';
import 'package:radiology_center_app/core/services/api/api_services.dart';

class OverviewState {
  final int totalDevices;
  final int totalAppointments;
  final int totalUsers;
  final bool isLoading;

  OverviewState({
    this.totalDevices = 0,
    this.totalAppointments = 0,
    this.totalUsers = 0,
    this.isLoading = false,
  });
}

class OverviewCubit extends Cubit<OverviewState> {
  final ApiServices _apiServices = ApiServices();

  OverviewCubit() : super(OverviewState());

  Future<void> fetchStats() async {
    // نتحقق إذا كان الـ Cubit مغلقاً قبل إصدار أي State جديد لتجنب الأخطاء
    if (isClosed) return;

    emit(OverviewState(isLoading: true));
    try {
      final devicesRes = await _apiServices.getData(
        url: "http://127.0.0.1:8000/api/radiology/devices/",
        token: ConstantData.tokenValue,
      );
      final bookedRes = await _apiServices.getData(
        url: "http://127.0.0.1:8000/api/radiology/booked-appointments/",
        token: ConstantData.tokenValue,
      );
      final usersRes = await _apiServices.getData(
        url: "http://127.0.0.1:8000/api/accounts/users/",
        token: ConstantData.tokenValue,
      );

      // التأكد من الوصول للمفاتيح الصحيحة بناءً على الـ Log الخاص بك
      int devicesCount = (devicesRes as List).length;
      int appointmentsCount = (bookedRes['data'] as List).length; // هنا التعديل
      int usersCount = (usersRes as List).length;

      if (!isClosed) {
        emit(
          OverviewState(
            totalDevices: devicesCount,
            totalAppointments: appointmentsCount,
            totalUsers: usersCount,
            isLoading: false,
          ),
        );
      }
    } catch (e) {
      print("Overview Error: $e");
      if (!isClosed) emit(OverviewState(isLoading: false));
    }
  }
}
