import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radiology_center_app/core/constant/constant.dart';
import 'package:radiology_center_app/core/services/api/api_link.dart';
import 'package:radiology_center_app/core/services/api/api_services.dart';
import 'package:radiology_center_app/core/services/services.dart';

import 'admin_state.dart';
import '../../../../data/repository/admin_repository.dart';
import '../../../../models/user_model.dart';

class AdminCubit extends Cubit<AdminState> {
  final AdminRepository _repository = AdminRepository();
  final ApiServices _apiServices = ApiServices();
  final SharedPreferencesService token = SharedPreferencesService();

  AdminCubit() : super(AdminInitial());

  // ========================
  // جلب كل المستخدمين
  // ========================
  Future<void> fetchAllUsers() async {
    emit(AdminLoading());
    try {
      final List<UserModel> users = await _repository.getAllUsers();
      emit(AdminLoadSuccess(users));
    } catch (e) {
      emit(AdminError("Failed to fetch users: $e"));
    }
  }

  // ========================
  // إضافة مستخدم
  // ========================
  Future<void> createUser(Map<String, dynamic> data) async {
    final currentState = state;
    List<UserModel> currentUsers = [];

    if (currentState is AdminLoadSuccess) {
      currentUsers = currentState.users;
    } else if (currentState is AdminOperationSuccess) {
      currentUsers = currentState.users;
    }

    emit(AdminOperationLoading(users: currentUsers));

    try {
      await _repository.createUser(data);

      // إعادة جلب المستخدمين بعد الإضافة
      final users = await _repository.getAllUsers();
      emit(AdminOperationSuccess("User created successfully", users));
    } catch (e) {
      emit(AdminError("Failed to create user: $e"));
      emit(AdminLoadSuccess(currentUsers));
    }
  }

  // ========================
  // حذف مستخدم
  // ========================
  Future<void> deleteUser(int id) async {
    final currentState = state;
    List<UserModel> currentUsers = [];

    if (currentState is AdminLoadSuccess) {
      currentUsers = currentState.users;
    } else if (currentState is AdminOperationSuccess) {
      currentUsers = currentState.users;
    } else {
      return; // لا يوجد بيانات للحذف
    }

    emit(AdminOperationLoading(users: currentUsers));

    try {
      await _apiServices.deleteData(
        url: ApiLink.deleteUser(id),
        token: ConstantData.tokenValue,
      );

      // تحديث القائمة بعد الحذف
      final updatedUsers =
          currentUsers.where((user) => user.id != id).toList();

      emit(AdminOperationSuccess("User deleted successfully", updatedUsers));
    } catch (e) {
      emit(AdminError("Failed to delete user: $e"));
      emit(AdminLoadSuccess(currentUsers));
    }
  }

  // ========================
  // تعديل مستخدم
  // ========================
  Future<void> updateUser(int id, Map<String, dynamic> newData) async {
    final currentState = state;
    List<UserModel> currentUsers = [];

    if (currentState is AdminLoadSuccess) {
      currentUsers = currentState.users;
    } else if (currentState is AdminOperationSuccess) {
      currentUsers = currentState.users;
    } else {
      return; // لا يوجد بيانات للتعديل
    }

    emit(AdminOperationLoading(users: currentUsers));

    try {
      await _repository.updateUser(id, newData);

      // إعادة جلب المستخدمين بعد التعديل
      final users = await _repository.getAllUsers();
      emit(AdminOperationSuccess("User updated successfully", users));
    } catch (e) {
      emit(AdminError("Failed to update user: $e"));
      emit(AdminLoadSuccess(currentUsers));
    }
  }
}
