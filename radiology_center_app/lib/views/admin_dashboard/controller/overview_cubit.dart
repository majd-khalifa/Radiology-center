// ignore_for_file: avoid_print

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radiology_center_app/core/constant/constant.dart';
import 'package:radiology_center_app/core/services/api/api_link.dart';
import 'package:radiology_center_app/core/services/api/api_services.dart';
import 'overview_state.dart';

class OverviewCubit extends Cubit<OverviewState> {
  final ApiServices _apiServices = ApiServices();

  // ============================
  // CACHE
  // ============================
  List<dynamic> _cachedDevices = [];
  List<dynamic> _cachedUsers = [];
  List<dynamic> _cachedAllAppointments = [];
  List<dynamic> _cachedBookedAppointments = [];

  OverviewCubit() : super(OverviewState());

  // ============================
  // FETCH STATS (with caching)
  // ============================
  Future<void> fetchStats() async {
    emit(state.copyWith(isLoading: true, isError: false));

    try {
      // 1) Devices
      if (_cachedDevices.isEmpty) {
        _cachedDevices = await _apiServices.getData(
          url: ApiLink.devices,
          token: ConstantData.tokenValue,
        );
      }
      int devicesCount = _cachedDevices.length;

      // 2) Users
      if (_cachedUsers.isEmpty) {
        _cachedUsers = await _apiServices.getData(
          url: ApiLink.getAllUsers,
          token: ConstantData.tokenValue,
        );
      }
      int usersCount = _cachedUsers.length;

      // 3) Booked appointments
      if (_cachedBookedAppointments.isEmpty) {
        final bookedRes = await _apiServices.getData(
          url: ApiLink.bookedAppointments,
          token: ConstantData.tokenValue,
        );
        _cachedBookedAppointments = bookedRes["data"];
      }
      int bookedCount = _cachedBookedAppointments.length;

      // 4) All appointments
      if (_cachedAllAppointments.isEmpty) {
        _cachedAllAppointments = await _apiServices.getData(
          url: ApiLink.allAppointments,
          token: ConstantData.tokenValue,
        );
      }
      int totalAppointments = _cachedAllAppointments.length;

      // 5) Available appointments
      int availableAppointments = totalAppointments - bookedCount;

      // 6) Today
      String today = DateTime.now().toString().split(" ")[0];
      int todayCount = _cachedAllAppointments
          .where((e) => e["date"] == today)
          .length;

      // 7) Weekly
      DateTime now = DateTime.now();
      DateTime weekAgo = now.subtract(const Duration(days: 7));
      int weeklyCount = _cachedAllAppointments
          .where((e) => DateTime.parse(e["date"]).isAfter(weekAgo))
          .length;

      emit(
        state.copyWith(
          isLoading: false,
          totalDevices: devicesCount,
          totalUsers: usersCount,
          totalAppointments: totalAppointments,
          bookedAppointments: bookedCount,
          availableAppointments: availableAppointments,
          todayAppointments: todayCount,
          weeklyAppointments: weeklyCount,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, isError: true));
    }
  }

  // ============================
  // LOCAL UPDATE AFTER CRUD
  // ============================

  // إضافة موعد جديد
  void addAppointmentToOverview(Map<String, dynamic> data) {
    _cachedAllAppointments.add(data);

    if (data["is_available"] == false) {
      _cachedBookedAppointments.add(data);
    }

    fetchStats();
  }

  // تعديل موعد
  void updateAppointmentInOverview(int id, Map<String, dynamic> data) {
    final index = _cachedAllAppointments.indexWhere((e) => e["id"] == id);
    if (index != -1) {
      _cachedAllAppointments[index]["date"] = data["date"];
      _cachedAllAppointments[index]["time"] = data["time"];
    }

    fetchStats();
  }

  // حذف موعد
  void removeAppointmentFromOverview(int id) {
    _cachedAllAppointments.removeWhere((e) => e["id"] == id);
    _cachedBookedAppointments.removeWhere((e) => e["id"] == id);

    fetchStats();
  }
}
