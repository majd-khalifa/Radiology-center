// lib/views/admin_dashboard/controller/admin_state.dart
import 'package:radiology_center_app/models/user_model.dart';

abstract class AdminState {}

class AdminInitial extends AdminState {}

class AdminLoading extends AdminState {}

class AdminSuccess extends AdminState {
  final List<UserModel> users;
  AdminSuccess(this.users);
}

class AdminError extends AdminState {
  final String message;
  AdminError(this.message);
}
