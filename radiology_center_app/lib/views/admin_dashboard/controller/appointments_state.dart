import 'package:radiology_center_app/models/appointment_model.dart';

abstract class AppointmentsState {}

class AppointmentsInitial extends AppointmentsState {}

class AppointmentsLoading extends AppointmentsState {}

class AppointmentsSuccess extends AppointmentsState {
  final List<AppointmentModel> appointments;
  AppointmentsSuccess(this.appointments);
}

class AppointmentsError extends AppointmentsState {
  final String message;
  AppointmentsError(this.message);
}
