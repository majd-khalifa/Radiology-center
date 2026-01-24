// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radiology_center_app/core/constant/constant.dart';
import 'package:radiology_center_app/core/services/api/api_services.dart';
import 'package:radiology_center_app/models/device_model.dart';
import 'device_state.dart'; // استيراد الحالات

class DevicesCubit extends Cubit<DevicesState> {
  final ApiServices _apiServices = ApiServices();
  final String baseUrl = "http://127.0.0.1:8000/api/radiology/devices/";

  DevicesCubit() : super(DevicesInitial());

  // 1. جلب قائمة الأجهزة من السيرفر
  Future<void> fetchDevices() async {
    emit(DevicesLoading());
    try {
      final response = await _apiServices.getData(
        url: baseUrl,
        token: ConstantData.tokenValue,
      );

      // التأكد من هيكلية البيانات القادمة من JSON
      List<dynamic> data = response is List ? response : response['data'] ?? [];
      List<DeviceModel> devices = data
          .map((e) => DeviceModel.fromJson(e))
          .toList();

      emit(DevicesSuccess(devices));
    } catch (e) {
      emit(DevicesFailure("فشل جلب البيانات: ${e.toString()}"));
    }
  }

  // 2. إضافة جهاز جديد
  Future<void> addDevice(DeviceModel device) async {
    try {
      await _apiServices.postData(
        url: baseUrl,
        body: device.toJson(),
        token: ConstantData.tokenValue,
      );
      fetchDevices(); // إعادة تحديث القائمة فوراً بعد الإضافة
    } catch (e) {
      emit(DevicesFailure("فشل إضافة الجهاز: ${e.toString()}"));
    }
  }

  // 3. حذف جهاز بناءً على الـ ID
  Future<void> deleteDevice(int id) async {
    try {
      await _apiServices.deleteData(
        url: "$baseUrl$id/",
        token: ConstantData.tokenValue,
      );
      fetchDevices(); // إعادة تحديث القائمة فوراً بعد الحذف
    } catch (e) {
      emit(DevicesFailure("فشل حذف الجهاز: ${e.toString()}"));
    }
  }

  // أضف هذه الدالة داخل class DevicesCubit

  Future<void> editDevice(int id, Map<String, dynamic> updatedData) async {
    try {
      await _apiServices.putData(
        url: "${baseUrl}$id/", // الرابط بناءً على Log السيرفر
        body: updatedData,
        token: ConstantData.tokenValue,
      );
      fetchDevices(); // تحديث الواجهة فوراً
    } catch (e) {
      emit(DevicesFailure("فشل تعديل الجهاز: $e"));
    }
  }
}
