// views/patient_dashboard/appointment/appointment_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radiology_center_app/core/constant/app_color.dart';
import 'package:radiology_center_app/core/constant/text_style.dart';
import 'package:radiology_center_app/core/helper/snack_bar_helper.dart';
import 'package:radiology_center_app/core/services/api/api_link.dart';
import 'package:radiology_center_app/core/services/api/api_services.dart';
import 'package:radiology_center_app/core/widgets/background_image.dart';
import 'package:radiology_center_app/core/widgets/custom_app_bar.dart';
import 'package:radiology_center_app/core/widgets/green_button.dart';
import 'package:radiology_center_app/models/slots_model.dart';
import 'package:radiology_center_app/views/patient_dashboard/appointment/widgets/appointment_date_item.dart';
import 'package:radiology_center_app/views/patient_dashboard/appointment/widgets/device_info_card.dart';
import 'package:radiology_center_app/views/patient_dashboard/patient_details/widgets/custom_text.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  final ApiServices api = ApiServices();
  List<SlotModel> allSlots = [];
  List<SlotModel> morningSlots = [];
  List<SlotModel> afternoonSlots = [];

  bool isLoadingSlots = false;
  DateTime selectedDate = DateTime.now();
  int selectedDateIndex = 0;
  SlotModel? selectedSlot;
  bool isBooking = false;
  late List<DateTime> dates;
  String getDateTitle(DateTime date, int index) {
    if (index == 0) return "Today";
    if (index == 1) return "Tomorrow";

    return "${date.day}/${date.month}";
  }

  Future<void> bookSelectedSlot() async {
    if (selectedSlot == null) return;

    setState(() => isBooking = true);

    try {
      final url = ApiLink.bookAppointment(
        selectedSlot!.id,
      ); // 🔥 استخدم الرابط الجديد

      final response = await api.postData(
        url: url,
        body: {}, // غالبًا لا يحتاج body حسب الـ API
        token:
            "baa64c0e501dc632a908100f3ac9e01f9a77f1d4", // استبدل بالتوكن الحقيقي
      );

      if (response != null && response['message'] != null) {
        SnackBarHelper.showSuccess(context, response['message']);

        // إزالة السلوت المحجوز من القوائم
        setState(() {
          morningSlots.remove(selectedSlot);
          afternoonSlots.remove(selectedSlot);
          selectedSlot = null;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
      SnackBarHelper.showError(context, "Failed to book appointment");
    } finally {
      setState(() => isBooking = false);
    }
  }

  Future<void> loadSlots() async {
    setState(() {
      isLoadingSlots = true;
      morningSlots.clear();
      afternoonSlots.clear();
    });

    try {
      final slots = await api.getDeviceSlots(
        deviceId: 1, // 🔴 غيّرها حسب الجهاز
        token: "baa64c0e501dc632a908100f3ac9e01f9a77f1d4",
      );
      //       final now = DateTime.now();

      // final filtered = slots.where((slot) {
      //   // slot.date هو DateTime من API
      //   final slotDateTime = DateTime(
      //     slot.date.year,
      //     slot.date.month,
      //     slot.date.day,
      //     int.parse(slot.time.split(':')[0]),
      //     int.parse(slot.time.split(':')[1]),
      //   );

      //   return slot.isAvailable && slotDateTime.isAfter(now);
      // });

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

  void generateDates() {
    dates = List.generate(
      7,
      (index) => DateTime.now().add(Duration(days: index)),
    );

    selectedDate = dates[0];
  }

  @override
  void initState() {
    super.initState();
    generateDates();
    loadSlots();
  }

  @override
  Widget build(BuildContext context) {
    return Backgroundimage(
      child: Scaffold(
        backgroundColor: AppColor.gradientWhite,
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
                      const DeviceInfoCard(),
                      SizedBox(height: 25.h),

                      // اختيار التاريخ
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

                                  loadSlots(); // 🔥 هون الربط
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
                      // مكان سابق لـ slots
                      if (isLoadingSlots) ...[
                        const Center(child: CircularProgressIndicator()),
                      ] else ...[
                        // Morning slots
                        if (morningSlots.isNotEmpty) ...[
                          CustomText(text: "morning"),
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

                        // Afternoon slots
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

                        // لا توجد slots
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
                    : bookSelectedSlot, // 🔥 دالة الحجز الجديدة
              ),
            ],
          ),
        ),
      ),
    );
  }
}
