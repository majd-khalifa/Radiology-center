import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radiology_center_app/core/constant/constant.dart';
import 'package:radiology_center_app/core/services/api/api_link.dart';
import 'package:radiology_center_app/core/services/api/api_services.dart';
import 'package:radiology_center_app/models/device_model.dart';
import 'device_state.dart';

class DevicesCubit extends Cubit<DevicesState> {
  final ApiServices _apiServices = ApiServices();
  final String baseUrl = "http://127.0.0.1:8000/api/radiology/devices/";

  DevicesCubit() : super(DevicesInitial());

  // ========================
  // 1) جلب الأجهزة
  // ========================
  Future<void> fetchDevices() async {
    emit(DevicesLoading());
    try {
      final response = await _apiServices.getData(
        url: ApiLink.devices,
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

  // ========================
  // 2) إضافة جهاز
  // ========================
  Future<void> addDevice(DeviceModel device) async {
    final currentState = state;
    if (currentState is! DevicesLoadSuccess) return;

    emit(DeviceOperationLoading());
    try {
      final response = await _apiServices.postData(
        url: ApiLink.postDevice,
        body: device.toJson(),
        token: ConstantData.tokenValue,
      );

      final newDevice = DeviceModel.fromJson(response);

      final updatedList = [...currentState.devices, newDevice];

      emit(DevicesLoadSuccess(updatedList));
    } catch (e) {
      emit(DevicesFailure("فشل إضافة الجهاز: $e"));
    }
  }

  // ========================
  // 3) تعديل جهاز
  // ========================
  Future<void> editDevice(int id, Map<String, dynamic> updatedData) async {
    final currentState = state;
    if (currentState is! DevicesLoadSuccess) return;

    emit(DeviceOperationLoading());
    try {
      final response = await _apiServices.putData(
        url: "${ApiLink.devices}$id/",
        body: updatedData,
        token: ConstantData.tokenValue,
      );

      final updatedDevice = DeviceModel.fromJson(response);

      final updatedList = currentState.devices.map((device) {
        if (device.id == id) return updatedDevice;
        return device;
      }).toList();

      emit(DevicesLoadSuccess(updatedList));
    } catch (e) {
      emit(DevicesFailure("فشل تعديل الجهاز: $e"));
    }
  }

  // ========================
  // 4) حذف جهاز
  // ========================
  Future<void> deleteDevice(int id) async {
    final currentState = state;
    if (currentState is! DevicesLoadSuccess) return;

    emit(DeviceOperationLoading());
    try {
      await _apiServices.deleteData(
        url: "${ApiLink.devices}$id/",
        token: ConstantData.tokenValue,
      );

      final updatedList = currentState.devices
          .where((device) => device.id != id)
          .toList();

      emit(DevicesLoadSuccess(updatedList));
    } catch (e) {
      emit(DevicesFailure("فشل حذف الجهاز: $e"));
    }
  }
}
