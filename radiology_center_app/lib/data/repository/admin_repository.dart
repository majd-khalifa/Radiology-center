import '../../models/user_model.dart';
import '../../models/device_model.dart';
import '../../../core/services/api/api_services.dart';
import '../../../core/services/api/api_link.dart';
import '../../../core/constant/constant.dart';

class AdminRepository {
  final ApiServices _apiServices = ApiServices();

  // ================================
  // 1) جلب كل المستخدمين
  // ================================
  Future<List<UserModel>> getAllUsers() async {
    final response = await _apiServices.getData(
      url: ApiLink.getAllUsers,
      token: ConstantData.tokenValue,
    );

    if (response is List) {
      return response.map((e) => UserModel.fromJson(e)).toList();
    }

    return [];
  }

  // ================================
  // 2) جلب مستخدم واحد
  // ================================
  Future<UserModel> getUserById(int id) async {
    final response = await _apiServices.getData(
      url: ApiLink.getUser(id),
      token: ConstantData.tokenValue,
    );

    return UserModel.fromJson(response);
  }

  // ================================
  // 3) إنشاء مستخدم جديد (اختياري)
  // ================================
  Future<void> createUser(Map<String, dynamic> data) async {
    await _apiServices.postData(
      url: ApiLink.createUser,
      body: data,
      token: ConstantData.tokenValue,
    );
  }

  // ================================
  // 4) تعديل مستخدم
  // ================================
  Future<void> updateUser(int id, Map<String, dynamic> data) async {
    await _apiServices.putData(
      url: ApiLink.editUser(id),
      body: data,
      token: ConstantData.tokenValue,
    );
  }

  // ================================
  // 5) حذف مستخدم
  // ================================
  Future<void> deleteUserAccount(int id) async {
    await _apiServices.deleteData(
      url: ApiLink.deleteUser(id),
      token: ConstantData.tokenValue,
    );
  }

  // ================================
  // 6) جلب الأجهزة
  // ================================
  Future<List<DeviceModel>> getDevices() async {
    final response = await _apiServices.getData(
      url: ApiLink.devices,
      token: ConstantData.tokenValue,
    );

    if (response is List) {
      return response.map((e) => DeviceModel.fromJson(e)).toList();
    }

    return [];
  }
}
