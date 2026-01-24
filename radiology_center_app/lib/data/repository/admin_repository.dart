// lib/data/repository/admin_repository.dart
import '../../models/user_model.dart';
import '../../models/device_model.dart';
import '../../../core/services/api/api_services.dart';
import '../../../core/services/api/api_link.dart';
import '../../../core/constant/constant.dart';

class AdminRepository {
  final ApiServices _apiServices = ApiServices();

  // جلب الحسابات
  Future<List<UserModel>> getAllUsers() async {
    final response = await _apiServices.getData(
      url: ApiLink.getAllUsers,
      token: ConstantData.tokenValue,
    );
    return (response as List).map((e) => UserModel.fromJson(e)).toList();
  }

  // حذف حساب مستخدم
  Future<void> deleteUserAccount(int id) async {
    await _apiServices.deleteData(
      // تأكد من إضافة ميثود deleteData في ApiServices
      url: ApiLink.deleteUser(id),
      token: ConstantData.tokenValue,
    );
  }

  // جلب الأجهزة
  Future<List<DeviceModel>> getDevices() async {
    final response = await _apiServices.getData(
      url: ApiLink.devices,
      token: ConstantData.tokenValue,
    );
    return (response as List).map((e) => DeviceModel.fromJson(e)).toList();
  }
}
