// views/patient_dashboard/appointment/appointment_screen.dart
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radiology_center_app/core/constant/app_color.dart';
import 'package:radiology_center_app/core/constant/constant.dart';
import 'package:radiology_center_app/core/constant/text_style.dart';
import 'package:radiology_center_app/core/helper/snack_bar_helper.dart';
import 'package:radiology_center_app/core/services/api/api_link.dart';
import 'package:radiology_center_app/core/services/api/api_services.dart';
import 'package:radiology_center_app/core/widgets/background_image.dart';
import 'package:radiology_center_app/core/widgets/custom_app_bar.dart';
import 'package:radiology_center_app/core/widgets/green_button.dart';
import 'package:radiology_center_app/models/device_model.dart';
import 'package:radiology_center_app/models/slots_model.dart';
import 'package:radiology_center_app/views/patient_dashboard/appointment/widgets/appointment_date_item.dart';
import 'package:radiology_center_app/views/patient_dashboard/appointment/widgets/device_info_card.dart';
import 'package:radiology_center_app/views/patient_dashboard/appointment/widgets/time_slot_item.dart';
import 'package:radiology_center_app/views/patient_dashboard/patient_details/widgets/custom_text.dart';

class AppointmentScreen extends StatefulWidget {
  final int deviceId;

  const AppointmentScreen({super.key, required this.deviceId});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  final ApiServices api = ApiServices();

  DeviceModel? device;
  bool isLoadingDevice = true;

  List<SlotModel> morningSlots = [];
  List<SlotModel> afternoonSlots = [];
  bool isLoadingSlots = false;

  DateTime selectedDate = DateTime.now();
  int selectedDateIndex = 0;
  SlotModel? selectedSlot;
  bool isBooking = false;

  late List<DateTime> dates;

  // ---------------- DEVICE INFO ----------------

  Future<void> loadDeviceInfo() async {
    try {
      device = await api.getDeviceInfo(
        widget.deviceId,
        ConstantData.tokenValue,
      );
    } catch (e) {
      debugPrint("Error loading device info: $e");
    }

    setState(() => isLoadingDevice = false);
  }

  // ---------------- SLOTS ----------------

  Future<void> loadSlots() async {
    setState(() {
      isLoadingSlots = true;
      morningSlots.clear();
      afternoonSlots.clear();
    });

    try {
      final slots = await api.getDeviceSlots(
        deviceId: widget.deviceId,
        token: ConstantData.tokenValue,
      );

      final selectedDateStr = selectedDate.toIso8601String().split('T').first;

      final filtered = slots.where((slot) {
        final slotDate = slot.date.toIso8601String().split('T').first;
        return slotDate == selectedDateStr && slot.isAvailable;
      });

      for (final slot in filtered) {
        final hour = int.parse(slot.time.split(':')[0]);
        if (hour < 12) {
          morningSlots.add(slot);
        } else {
          afternoonSlots.add(slot);
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    setState(() => isLoadingSlots = false);
  }

  // ---------------- BOOKING ----------------

  Future<void> bookSelectedSlot() async {
    if (selectedSlot == null) return;

    setState(() => isBooking = true);

    try {
      final url = ApiLink.bookAppointment(selectedSlot!.id);

      final response = await api.postData(
        url: url,
        body: {},
        token: ConstantData.tokenValue,
      );

      if (response != null && response['message'] != null) {
        // عرض رسالة نجاح
        SnackBarHelper.showSuccess(context, response['message']);

        setState(() {
          morningSlots.remove(selectedSlot);
          afternoonSlots.remove(selectedSlot);
          selectedSlot = null;
        });

        // رجّع قيمة true للـ HomePage حتى يعمل تحديث
        Navigator.pop(context, true);
      }
    } catch (e) {
      SnackBarHelper.showError(context, "Failed to book appointment");
    } finally {
      setState(() => isBooking = false);
    }
  }

  // ---------------- DATES ----------------

  void generateDates() {
    dates = List.generate(
      7,
      (index) => DateTime.now().add(Duration(days: index)),
    );
    selectedDate = dates[0];
  }

  String getDateTitle(DateTime date, int index) {
    if (index == 0) return "Today";
    if (index == 1) return "Tomorrow";
    return "${date.day}/${date.month}";
  }

  // ---------------- INIT ----------------

  @override
  void initState() {
    super.initState();
    generateDates();
    loadSlots();
    loadDeviceInfo();
  }

  // ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {
    return Backgroundimage(
      child: Scaffold(
        backgroundColor: const Color(0xFFF3FFF8),

        body: SafeArea(
          child: Column(
            children: [
              const CustomAppBar(title: "Select Time"),

              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      device == null
                          ? const Center(child: CircularProgressIndicator())
                          : DeviceInfoCard(device: device!),

                      SizedBox(height: 25.h),

                      // ---------------- DATE SELECTOR ----------------
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                            dates.length,
                            (index) => Padding(
                              padding: EdgeInsets.only(right: 10.w),
                              child: AppointmentDateItem(
                                day: getDateTitle(dates[index], index),
                                subtitle: "Slots available",
                                isSelected: selectedDateIndex == index,
                                onTap: () {
                                  setState(() {
                                    selectedDateIndex = index;
                                    selectedDate = dates[index];
                                    selectedSlot = null;
                                  });

                                  loadSlots();
                                },
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 25.h),

                      Center(
                        child: Text(
                          getDateTitle(selectedDate, selectedDateIndex),
                          style: AppTextStyles.textStyle18.copyWith(
                            color: AppColor.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // ---------------- SLOTS ----------------
                      if (isLoadingSlots)
                        const Center(child: CircularProgressIndicator())
                      else ...[
                        if (morningSlots.isNotEmpty) ...[
                          CustomText(text: "Morning"),
                          SizedBox(height: 10.h),
                          Wrap(
                            spacing: 10.w,
                            runSpacing: 10.h,
                            children: morningSlots.map((slot) {
                              return TimeSlotItem(
                                time: slot.time,
                                isSelected: selectedSlot?.id == slot.id,
                                onTap: () {
                                  setState(() {
                                    selectedSlot = slot;
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ],

                        SizedBox(height: 20.h),

                        if (afternoonSlots.isNotEmpty) ...[
                          CustomText(text: "Afternoon"),
                          SizedBox(height: 10.h),
                          Wrap(
                            spacing: 10.w,
                            runSpacing: 10.h,
                            children: afternoonSlots.map((slot) {
                              return TimeSlotItem(
                                time: slot.time,
                                isSelected: selectedSlot?.id == slot.id,
                                onTap: () {
                                  setState(() {
                                    selectedSlot = slot;
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ],

                        if (morningSlots.isEmpty && afternoonSlots.isEmpty)
                          const Center(
                            child: CustomText(text: "No slots available"),
                          ),
                      ],
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20.h),

              GreenButton(
                widget: isBooking
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : CustomText(text: "Book"),
                onPressed: (selectedSlot == null || isBooking)
                    ? null
                    : bookSelectedSlot,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
