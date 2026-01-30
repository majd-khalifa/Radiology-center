// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radiology_center_app/core/constant/constant.dart';
import 'package:radiology_center_app/core/services/api/api_link.dart';
import 'package:radiology_center_app/core/services/api/api_services.dart';
import 'package:radiology_center_app/models/device_model.dart';
import 'device_state.dart'; // استيراد الحالات

class DevicesCubit extends Cubit<DevicesState> {
  final ApiServices _apiServices = ApiServices();
  final String baseUrl = "${ApiLink.baseUrl}/api/radiology/devices/";

  DevicesCubit() : super(DevicesInitial());

  // ================================
  // 1) جلب الأجهزة
  // ================================
  Future<void> fetchDevices() async {
    emit(DevicesLoading());
    try {
      final response = await _apiServices.getData(
        url: baseUrl,
        token: ConstantData.tokenValue,
      );

      List<DeviceModel> devices = (response as List)
          .map((e) => DeviceModel.fromJson(e))
          .toList();

      emit(DevicesLoadSuccess(devices));
    } catch (e) {
      emit(DevicesFailure("فشل جلب الأجهزة: $e"));
    }
  }

  // ================================
  // 2) جلب جهاز واحد
  // ================================
  Future<DeviceModel?> getDeviceById(int id) async {
    try {
      final response = await _apiServices.getData(
        url: "$baseUrl$id/",
        token: ConstantData.tokenValue,
      );
      return DeviceModel.fromJson(response);
    } catch (e) {
      emit(DevicesFailure("فشل جلب الجهاز: $e"));
      return null;
    }
  }

  // ================================
  // 3) إضافة جهاز
  // ================================
  Future<void> addDevice(DeviceModel device) async {
    final currentState = state;
    if (currentState is! DevicesLoadSuccess) return;

    emit(DeviceOperationLoading());
    try {
      await _apiServices.postData(
        url: baseUrl,
        body: device.toJson(),
        token: ConstantData.tokenValue,
      );

      await fetchDevices();
      emit(
        DeviceOperationSuccess("تمت إضافة الجهاز بنجاح", currentState.devices),
      );
    } catch (e) {
      emit(DevicesFailure("فشل إضافة الجهاز: $e"));
    }
  }

  // ================================
  // 4) تعديل جهاز
  // ================================
  Future<void> editDevice(int id, Map<String, dynamic> updatedData) async {
    final currentState = state;
    if (currentState is! DevicesLoadSuccess) return;

    emit(DeviceOperationLoading());
    try {
      await _apiServices.putData(
        url: "$baseUrl$id/",
        body: updatedData,
        token: ConstantData.tokenValue,
      );

      await fetchDevices();
      emit(
        DeviceOperationSuccess("تم تعديل الجهاز بنجاح", currentState.devices),
      );
    } catch (e) {
      emit(DevicesFailure("فشل تعديل الجهاز: $e"));
    }
  }

  // ================================
  // 5) حذف جهاز
  // ================================
  Future<void> deleteDevice(int id) async {
    final currentState = state;
    if (currentState is! DevicesLoadSuccess) return;

    emit(DeviceOperationLoading());
    try {
      await _apiServices.deleteData(
        url: "$baseUrl$id/",
        token: ConstantData.tokenValue,
      );

      await fetchDevices();
      emit(DeviceOperationSuccess("تم حذف الجهاز بنجاح", currentState.devices));
    } catch (e) {
      emit(DevicesFailure("فشل حذف الجهاز: $e"));
    }
  }
}
