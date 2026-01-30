// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radiology_center_app/models/device_model.dart';
import 'package:radiology_center_app/views/admin_dashboard/controller/device_state.dart';

import '../controller/devices_cubit.dart';
import '../../../../core/constant/app_color.dart';
import '../../../../core/constant/text_style.dart';

class ManageDevicesTab extends StatelessWidget {
  const ManageDevicesTab({super.key});

  void showEditDeviceDialog(BuildContext context, DeviceModel device) {
    final nameController = TextEditingController(text: device.name);
    final descController = TextEditingController(text: device.description);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            "Edit Device",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Device Name
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Device Name"),
                ),

                // Description
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(labelText: "Description"),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final updatedData = {
                  "name": nameController.text,
                  "description": descController.text,
                };

                context.read<DevicesCubit>().editDevice(device.id, updatedData);

                Navigator.pop(context);
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }

  void showAddDeviceDialog(BuildContext context) {
    final nameController = TextEditingController();
    final specialtyController = TextEditingController();
    final descController = TextEditingController();
    final ratingController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            "Add Device",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Device Name"),
                ),
                TextField(
                  controller: specialtyController,
                  decoration: const InputDecoration(labelText: "Specialty"),
                ),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(labelText: "Description"),
                  maxLines: 2,
                ),
                TextField(
                  controller: ratingController,
                  decoration: const InputDecoration(labelText: "Rating (0–5)"),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final device = DeviceModel(
                  id: 0,
                  name: nameController.text,
                  specialty: specialtyController.text,
                  description: descController.text,
                  rating: double.tryParse(ratingController.text) ?? 0.0,
                );

                context.read<DevicesCubit>().addDevice(device);
                Navigator.pop(context);
              },
              child: const Text("Create"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DevicesCubit, DevicesState>(
      builder: (context, state) {
        // ============================
        // Loading
        // ============================
        if (state is DevicesLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // ============================
        // Error
        // ============================
        if (state is DevicesFailure) {
          return Center(
            child: Text(
              state.errorMessage,
              style: AppTextStyles.textStyle16.copyWith(color: AppColor.xIcon),
            ),
          );
        }

        // ============================
        // Success (Load or Operation)
        // ============================
        if (state is DevicesLoadSuccess || state is DeviceOperationSuccess) {
          final devices = state is DevicesLoadSuccess
              ? state.devices
              : (state as DeviceOperationSuccess).devices;

          return SingleChildScrollView(
            padding: EdgeInsets.all(20.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ============================
                // Title + Add Button
                // ============================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Manage Devices",
                      style: AppTextStyles.textStyle20.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColor.black,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        showAddDeviceDialog(context);
                      },
                      icon: const Icon(Icons.add),
                      label: const Text("Add Device"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.buttonBackground,
                        foregroundColor: AppColor.white,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20.h),

                // ============================
                // Devices List
                // ============================
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: devices.length,
                  itemBuilder: (context, index) {
                    final device = devices[index];

                    return Container(
                      margin: EdgeInsets.only(bottom: 15.h),
                      padding: EdgeInsets.all(12.r),
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Icon
                          CircleAvatar(
                            backgroundColor: AppColor.buttonBackground
                                .withOpacity(0.1),
                            child: const Icon(
                              Icons.biotech_rounded,
                              color: AppColor.buttonBackground,
                            ),
                          ),

                          SizedBox(width: 15.w),

                          // Device Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  device.name ,
                                  style: AppTextStyles.textStyle16.copyWith(
                                    color: AppColor.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  device.description,
                                  style: AppTextStyles.textStyle12.copyWith(
                                    color: AppColor.subtitleColor,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Edit Button
                          IconButton(
                            icon: const Icon(
                              Icons.edit_note,
                              color: AppColor.tosca,
                            ),
                            onPressed: () {
                              showEditDeviceDialog(context, device);
                            },
                          ),

                          // Delete Button
                          IconButton(
                            icon: const Icon(
                              Icons.delete_sweep,
                              color: AppColor.xIcon,
                            ),
                            onPressed: () {
                              context.read<DevicesCubit>().deleteDevice(
                                device.id,
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}
