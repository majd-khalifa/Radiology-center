import 'package:radiology_center_app/models/device_model.dart';

abstract class DevicesState {}

class DevicesInitial extends DevicesState {}

class DevicesLoading extends DevicesState {}

class DevicesSuccess extends DevicesState {
  final List<DeviceModel> devices;
  DevicesSuccess(this.devices);
}

class DevicesFailure extends DevicesState {
  final String errorMessage;
  DevicesFailure(this.errorMessage);
}
