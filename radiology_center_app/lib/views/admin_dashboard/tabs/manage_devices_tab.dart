import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radiology_center_app/models/device_model.dart';
import 'package:radiology_center_app/views/admin_dashboard/controller/device_state.dart';
import 'package:radiology_center_app/views/admin_dashboard/controller/devices_cubit.dart';
import '../../../../core/constant/app_color.dart';

class ManageDevicesTab extends StatelessWidget {
  const ManageDevicesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DevicesCubit()..fetchDevices(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            floatingActionButton: FloatingActionButton(
              backgroundColor: AppColor.primary,
              onPressed: () => _showAddDeviceDialog(context),
              child: const Icon(Icons.add, color: Colors.white),
            ),
            body: BlocBuilder<DevicesCubit, DevicesState>(
              builder: (context, state) {
                if (state is DevicesLoading)
                  return const Center(child: CircularProgressIndicator());
                if (state is DevicesFailure)
                  return Center(child: Text(state.errorMessage));
                if (state is DevicesSuccess) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: state.devices.length,
                    itemBuilder: (context, index) {
                      final device = state.devices[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          title: Text(
                            device.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "${device.specialty} - ⭐ ${device.rating}",
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => context
                                .read<DevicesCubit>()
                                .deleteDevice(device.id!),
                          ),
                        ),
                      );
                    },
                  );
                }
                return const SizedBox();
              },
            ),
          );
        },
      ),
    );
  }

  void _showAddDeviceDialog(BuildContext context) {
    final nameController = TextEditingController();
    final specController = TextEditingController();
    final rateController = TextEditingController();

    showDialog(
      context: context,
      builder: (dContext) => AlertDialog(
        title: const Text("إضافة جهاز"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "الاسم"),
            ),
            TextField(
              controller: specController,
              decoration: const InputDecoration(labelText: "التخصص"),
            ),
            TextField(
              controller: rateController,
              decoration: const InputDecoration(labelText: "التقييم"),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              final device = DeviceModel(
                name: nameController.text,
                specialty: specController.text,
                description: "New Device",
                rating: double.tryParse(rateController.text) ?? 0.0,
              );
              context.read<DevicesCubit>().addDevice(device);
              Navigator.pop(dContext);
            },
            child: const Text("إضافة"),
          ),
        ],
      ),
    );
  }
}
