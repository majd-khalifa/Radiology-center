// ignore_for_file: unnecessary_this, avoid_print

import 'package:radiology_center_app/core/constant/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  SharedPreferences? _sharedPrefences;

  // Lazy initialization
  Future<SharedPreferences> get _prefs async {
    return _sharedPrefences ??= await SharedPreferences.getInstance();
  }

  // استرجاع قيمة
  Future<String?> getStringValue(String key) async {
    final prefs = await _prefs;
    return prefs.getString(key);
  }

  // حفظ قيمة
  Future<void> saveStringValue(String key, String value) async {
    final prefs = await _prefs;
    await prefs.setString(key, value);
  }

  // حذف مفتاح
  Future<void> removeData(String key) async {
    final prefs = await _prefs;
    await prefs.remove(key);
  }

  // حفظ التوكن
  Future<void> saveTokenUser(String token) async {
    await saveStringValue(ConstantData.usertoken, token);
    ConstantData.tokenValue = token;
  }

  Future<void> saveUserEmail(String id) async {
    await saveStringValue(ConstantData.userid, id);
    ConstantData.idValue = id;
  }

  // حذف كل البيانات
  Future<void> removeAllData() async {
    final prefs = await _prefs;
    await prefs.clear();
    removeData(ConstantData.usertoken);
    removeData(ConstantData.userid);
  }
}
