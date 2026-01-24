// lib/views/admin_dashboard/controller/admin_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radiology_center_app/models/user_model.dart';
import 'admin_state.dart';
import '../../../../data/repository/admin_repository.dart';

class AdminCubit extends Cubit<AdminState> {
  final AdminRepository _repository = AdminRepository();

  AdminCubit() : super(AdminInitial());

  // جلب المستخدمين
  Future<void> fetchAllUsers() async {
    emit(AdminLoading());
    try {
      final users = await _repository.getAllUsers();
      emit(AdminSuccess(users));
    } catch (e) {
      emit(AdminError("Failed to fetch users: ${e.toString()}"));
    }
  }

  // حذف مستخدم
  Future<void> deleteUser(int id, List<UserModel> currentUsers) async {
    try {
      await _repository.deleteUserAccount(id);
      // بعد الحذف، نحدث القائمة ونرسل حالة النجاح الجديدة
      currentUsers.removeWhere((user) => user.id == id);
      emit(AdminSuccess(List.from(currentUsers)));
    } catch (e) {
      // يمكنك إرسال حالة خطأ مؤقتة هنا
    }
  }
}
