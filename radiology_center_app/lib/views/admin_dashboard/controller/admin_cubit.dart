// lib/views/admin_dashboard/controller/admin_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radiology_center_app/core/constant/constant.dart';
import 'package:radiology_center_app/core/services/api/api_link.dart';
import 'package:radiology_center_app/core/services/api/api_services.dart';
import 'package:radiology_center_app/models/user_model.dart';
import 'admin_state.dart';
import '../../../../data/repository/admin_repository.dart';

class AdminCubit extends Cubit<AdminState> {
  final AdminRepository _repository = AdminRepository();
  final ApiServices _apiServices = ApiServices();

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

  // أضف هذه الدالة داخل class AdminCubit في ملف admin_cubit.dart

  Future<void> updateUser(
    int id,
    Map<String, dynamic> newData,
    List<UserModel> currentUsers,
  ) async {
    try {
      // نستخدم PUT بناءً على ApiLink.editUser
      await _apiServices.putData(
        url: ApiLink.editUser(id),
        body: newData,
        token: ConstantData.tokenValue,
      );

      // تحديث القائمة محلياً بعد نجاح السيرفر
      int index = currentUsers.indexWhere((user) => user.id == id);
      if (index != -1) {
        // هنا نفترض أن الـ UserModel لديه دالة copyWith أو نقوم بتحديث الحقول يدوياً
        // للتبسيط، سنعيد جلب البيانات من السيرفر لضمان المزامنة
        fetchAllUsers();
      }
    } catch (e) {
      emit(AdminError("فشل تعديل المستخدم: ${e.toString()}"));
    }
  }
}
