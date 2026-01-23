import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radiology_center_app/core/constant/app_color.dart';
import 'package:radiology_center_app/core/constant/text_style.dart';
import 'package:radiology_center_app/core/widgets/background_image.dart';
import 'package:radiology_center_app/core/widgets/custom_app_bar.dart';
import 'package:radiology_center_app/core/widgets/green_button.dart';
import 'package:radiology_center_app/views/auth/widgets/my_text_field.dart';
import 'package:radiology_center_app/views/patient_details/widgets/custom_progress_bar.dart';
import 'package:radiology_center_app/views/patient_details/widgets/custom_text.dart';
import 'package:radiology_center_app/views/patient_details/widgets/drop_down_button.dart';
import 'package:radiology_center_app/views/patient_details/widgets/radio_item.dart';

class PatientDetails extends StatefulWidget {
  const PatientDetails({super.key});

  @override
  State<PatientDetails> createState() => _PatientDetailsState();
}

class _PatientDetailsState extends State<PatientDetails> {
  final _formKey = GlobalKey<FormState>();

  final patientNameController = TextEditingController();
  final phoneNumeberController = TextEditingController();
  final emailController = TextEditingController();

  final List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  String? selectedDay;
  String? selectedMonth;
  String? selectedYear;
  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  final List<String> years = [
    '2020',
    '2021',
    '2022',
    '2023',
    '2024',
    '2025',
    '2026',
  ];
  String selectedGender = '';
  final List<String> genders = ['Male', 'Female', 'Others'];
  String gender = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Backgroundimage(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomAppBar(title: "PatientDetails"),
                SizedBox(height: 24.h),
                Container(
                  height: 38.h,
                  width: 1.sw,
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    child: Row(
                      children: [
                        Text(
                          "Step 1/4 ",
                          style: AppTextStyles.textStyle14.copyWith(
                            color: AppColor.black,
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(child: CustomProgressBar(progress: 0.1)),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Container(
                  width: 1.sw,
                  height: 518.h,
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),

                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 28.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(text: "Patient’s Name"),
                            SizedBox(height: 9),
                            Mytextfield(
                              text: 'Abdullah Mamun',
                              controller: patientNameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "please enter a password";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16),
                            CustomText(text: "Age"),
                            SizedBox(height: 9),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                DropDownButton(
                                  item: "Day",
                                  items: days,
                                  selectedItem: selectedDay,
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() => selectedDay = value);
                                    }
                                  },
                                ),
                                DropDownButton(
                                  items: months,
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() => selectedMonth = value);
                                    }
                                  },
                                  selectedItem: selectedMonth,
                                  item: 'Month',
                                ),

                                DropDownButton(
                                  selectedItem: selectedYear,
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() => selectedYear = value);
                                    }
                                  },
                                  items: years,
                                  item: "Year",
                                ),
                              ],
                            ),
                            SizedBox(height: 18),
                            CustomText(text: "Gender"),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RadioItem(
                                  selectedGender: selectedGender,
                                  onChanged: (value) {
                                    setState(() => selectedGender = value!);
                                  },
                                  gender: 'Male',
                                ),
                                RadioItem(
                                  selectedGender: selectedGender,
                                  onChanged: (value) {
                                    setState(() => selectedGender = value!);
                                  },
                                  gender: 'female',
                                ),
                                RadioItem(
                                  selectedGender: selectedGender,
                                  onChanged: (value) {
                                    setState(() => selectedGender = value!);
                                  },
                                  gender: "Other",
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            CustomText(text: "Mobile Number"),
                            SizedBox(height: 9),
                            Mytextfield(
                              text: "+8801000000000",
                              controller: phoneNumeberController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "please enter a password";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 17),
                            CustomText(text: "Email"),
                            SizedBox(height: 9),
                            Mytextfield(
                              text: "itsmemamun1@gmail.com",
                              controller: emailController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "please enter a password";
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 38),
                GreenButton(
                  widget: Text(
                    "Continue",
                    style: AppTextStyles.textStyle18.copyWith(
                      color: AppColor.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
