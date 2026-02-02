import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radiology_center_app/core/constant/constant.dart';
import 'package:radiology_center_app/core/services/api/api_services.dart';
import 'device_state.dart';

class DeviceCubit extends Cubit<DevicesState> {
  final ApiServices _apiServices = ApiServices();

  DeviceCubit() : super(DevicesInitial());

  // تحديث بيانات جهاز معين
  Future<void> updateDevice(int id, Map<String, dynamic> data) async {
    try {
      await _apiServices.putData(
        url: "http://127.0.0.1:8000/api/radiology/devices/$id/",
        body: data,
        token: ConstantData.tokenValue,
      );
      // يمكن إضافة منطق إضافي هنا بعد التحديث بنجاح
    } catch (e) {
      emit(DevicesFailure("فشل تحديث الجهاز: ${e.toString()}"));
    }
  }
}
