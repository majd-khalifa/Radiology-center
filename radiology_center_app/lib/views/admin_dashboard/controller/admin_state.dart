import 'package:radiology_center_app/models/user_model.dart';

abstract class AdminState {}

class AdminInitial extends AdminState {}

class AdminLoading extends AdminState {}

class AdminOperationLoading extends AdminState {
  final List<UserModel> users;
  AdminOperationLoading({required this.users});
}

class AdminLoadSuccess extends AdminState {
  final List<UserModel> users;
  AdminLoadSuccess(this.users);
}

class AdminOperationSuccess extends AdminState {
  final String message;
  final List<UserModel> users;
  AdminOperationSuccess(this.message, this.users);
}

class AdminError extends AdminState {
  final String message;
  AdminError(this.message);
}
