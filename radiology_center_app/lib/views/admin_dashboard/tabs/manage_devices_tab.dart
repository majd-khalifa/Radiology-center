// lib/views/admin_dashboard/tabs/manage_devices_tab.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radiology_center_app/models/device_model.dart';
import '../controller/devices_cubit.dart';
import '../controller/device_state.dart';
import '../../../../core/constant/app_color.dart';

class ManageDevicesTab extends StatelessWidget {
  const ManageDevicesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DevicesCubit()..fetchDevices(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton(
            backgroundColor: AppColor.buttonBackground,
            onPressed: () => _showDeviceDialog(context),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
        body: BlocBuilder<DevicesCubit, DevicesState>(
          builder: (context, state) {
            if (state is DevicesLoading)
              return const Center(child: CircularProgressIndicator());
            if (state is DevicesSuccess) {
              return ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: state.devices.length,
                itemBuilder: (context, index) {
                  final device = state.devices[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      title: Text(
                        device.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "${device.specialty} • ⭐ ${device.rating}",
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: AppColor.tosca),
                            onPressed: () =>
                                _showDeviceDialog(context, device: device),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: AppColor.xIcon,
                            ),
                            onPressed: () => context
                                .read<DevicesCubit>()
                                .deleteDevice(device.id!),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  void _showDeviceDialog(BuildContext context, {DeviceModel? device}) {
    final nameController = TextEditingController(text: device?.name);
    final specController = TextEditingController(text: device?.specialty);
    final cubit = context.read<DevicesCubit>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(device == null ? "إضافة جهاز" : "تعديل جهاز"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "اسم الجهاز"),
            ),
            TextField(
              controller: specController,
              decoration: const InputDecoration(labelText: "التخصص"),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (device == null) {
                cubit.addDevice(
                  DeviceModel(
                    name: nameController.text,
                    specialty: specController.text,
                    rating: 0.0,
                    description: "",
                  ),
                );
              } else {
                cubit.editDevice(device.id!, {
                  "name": nameController.text,
                  "specialty": specController.text,
                });
              }
              Navigator.pop(context);
            },
            child: Text(device == null ? "إضافة" : "تحديث"),
          ),
        ],
      ),
    );
  }
}
