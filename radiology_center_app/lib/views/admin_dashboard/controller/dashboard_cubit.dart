// lib/views/admin_dashboard/controller/dashboard_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/api/api_services.dart';
import '../../../../core/services/api/api_link.dart';

abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardSuccess extends DashboardState {
  final int usersCount;
  final int devicesCount;
  final int appointmentsCount;
  DashboardSuccess({
    required this.usersCount,
    required this.devicesCount,
    required this.appointmentsCount,
  });
}

class DashboardCubit extends Cubit<DashboardState> {
  final ApiServices _apiServices = ApiServices();
  DashboardCubit() : super(DashboardInitial());

  Future<void> fetchStats() async {
    emit(DashboardLoading());
    try {
      // هنا منجيب البيانات من الـ APIs (مثال توضيحي)
      final users = await _apiServices.getData(url: ApiLink.getAllUsers);
      final devices = await _apiServices.getData(url: ApiLink.devices);

      emit(
        DashboardSuccess(
          usersCount: (users as List).length,
          devicesCount: (devices as List).length,
          appointmentsCount: 0, // منضيفها لما نربط المواعيد
        ),
      );
    } catch (e) {
      emit(DashboardInitial()); // أو حالة خطأ
    }
  }
}
