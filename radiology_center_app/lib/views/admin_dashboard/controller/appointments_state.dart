import 'package:radiology_center_app/models/appointment_model.dart';

abstract class AppointmentsState {}

class AppointmentsInitial extends AppointmentsState {}

class AppointmentsLoading extends AppointmentsState {}

class AppointmentsLoadSuccess extends AppointmentsState {
  final List<AppointmentModel> appointments;
  AppointmentsLoadSuccess(this.appointments);
}

class AppointmentOperationLoading extends AppointmentsState {}

class AppointmentOperationSuccess extends AppointmentsState {
  final String message;
  final List<AppointmentModel> appointments;
  AppointmentOperationSuccess(this.message, this.appointments);
}

class AppointmentsError extends AppointmentsState {
  final String message;
  AppointmentsError(this.message);
}
