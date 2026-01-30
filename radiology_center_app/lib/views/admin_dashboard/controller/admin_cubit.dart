// lib/views/admin_dashboard/controller/admin_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radiology_center_app/models/user_model.dart';
import 'admin_state.dart';
import '../../../../data/repository/admin_repository.dart';

class AdminCubit extends Cubit<AdminState> {
  final AdminRepository _repository = AdminRepository();

  AdminCubit() : super(AdminInitial());

  Future<void> createUser(Map<String, dynamic> data) async {
    final currentState = state;

    emit(AdminOperationLoading());
    try {
      await _repository.createUser(data);

      // بعد الإنشاء، نعيد جلب كل المستخدمين
      final users = await _repository.getAllUsers();

      emit(AdminOperationSuccess("User created successfully", users));
    } catch (e) {
      emit(AdminError("Failed to create user: $e"));

      // نرجع آخر حالة ناجحة إذا كانت موجودة
      if (currentState is AdminLoadSuccess) {
        emit(currentState);
      }
    }
  }

  Future<void> fetchAllUsers() async {
    emit(AdminLoading());
    try {
      final users = await _repository.getAllUsers();
      emit(AdminLoadSuccess(users));
    } catch (e) {
      emit(AdminError("Failed to fetch users: $e"));
    }
  }

  Future<void> deleteUser(int id) async {
    final currentState = state;
    if (currentState is! AdminLoadSuccess) return;

    emit(AdminOperationLoading());
    try {
      await _repository.deleteUserAccount(id);
      final updated = List<UserModel>.from(currentState.users)
        ..removeWhere((u) => u.id == id);
      emit(AdminOperationSuccess("User deleted successfully", updated));
    } catch (e) {
      emit(AdminError("Failed to delete user: $e"));
      emit(currentState); // نرجع آخر حالة ناجحة
    }
  }

  Future<void> updateUser(int id, Map<String, dynamic> newData) async {
    final currentState = state;
    if (currentState is! AdminLoadSuccess) return;

    emit(AdminOperationLoading());
    try {
      await _repository.updateUser(id, newData);

      // خيار 1: نعيد جلب الكل من السيرفر
      final users = await _repository.getAllUsers();
      emit(AdminOperationSuccess("User updated successfully", users));

      // خيار 2 (لو عندك copyWith): نحدّث محلياً بدون طلب جديد
    } catch (e) {
      emit(AdminError("Failed to update user: $e"));
      emit(currentState);
    }
  }
}
