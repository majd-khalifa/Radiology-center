import 'package:radiology_center_app/models/device_model.dart';

abstract class DevicesState {}

class DevicesInitial extends DevicesState {}

class DevicesLoading extends DevicesState {} // أثناء جلب الأجهزة

class DevicesLoadSuccess extends DevicesState {
  final List<DeviceModel> devices;
  DevicesLoadSuccess(this.devices);
}

class DeviceOperationLoading extends DevicesState {} // إضافة / تعديل / حذف

class DeviceOperationSuccess extends DevicesState {
  final String message;
  final List<DeviceModel> devices;
  DeviceOperationSuccess(this.message, this.devices);
}

class DevicesFailure extends DevicesState {
  final String errorMessage;
  DevicesFailure(this.errorMessage);
}
