import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radiology_center_app/core/constant/app_color.dart';
import 'package:radiology_center_app/core/constant/text_style.dart';
import 'package:radiology_center_app/core/widgets/background_image.dart';
import 'package:radiology_center_app/core/widgets/custom_app_bar.dart';
import 'package:radiology_center_app/views/auth/widgets/my_text_field.dart';
import 'package:radiology_center_app/views/patient_details/widgets/custom_progress_bar.dart';

class PatientDetails extends StatefulWidget {
  const PatientDetails({super.key});

  @override
  State<PatientDetails> createState() => _PatientDetailsState();
}

class _PatientDetailsState extends State<PatientDetails> {
  final _formKey = GlobalKey<FormState>();

  final patientNameController = TextEditingController();

  final List<String> days = [
    'Day',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  String selectedDay = 'Day';
  String selectedMonth = 'Month';
  String selectedYear = 'Year';
  final List<String> months = [
    'Month',
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
    'Year',
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
                        Expanded(child: CustomProgressBar(progress: 0.4)),
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
                          Text(
                            "Patient’s Name",
                            style: AppTextStyles.textStyle16.copyWith(
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.3,
                              color: AppColor.black,
                            ),
                          ),
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
                          Text(
                            "Age",
                            style: AppTextStyles.textStyle16.copyWith(
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.3,
                              color: AppColor.black,
                            ),
                          ),
                          SizedBox(height: 9),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 54.h,
                                width: 100.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppColor.subtitleColor,
                                    width: 1,
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    padding: EdgeInsets.only(left: 10),
                                    isExpanded: true,
                                    borderRadius: BorderRadius.circular(1.r),
                                    value: selectedDay,
                                    items: days.map((day) {
                                      return DropdownMenuItem(
                                        value: day,
                                        child: Text(
                                          day,
                                          style: AppTextStyles.textStyle16
                                              .copyWith(),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() => selectedDay = value);
                                      }
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                height: 54.h,
                                width: 100.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppColor.subtitleColor,
                                    width: 1,
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    padding: EdgeInsets.only(left: 10),
                                    isExpanded: true,
                                    borderRadius: BorderRadius.circular(1.r),
                                    value: selectedMonth,
                                    items: months.map((month) {
                                      return DropdownMenuItem(
                                        value: month,
                                        child: Text(month),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() => selectedMonth = value);
                                      }
                                    },
                                  ),
                                ),
                              ),

                              Container(
                                height: 54.h,
                                width: 100.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppColor.subtitleColor,
                                    width: 1,
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    padding: EdgeInsets.only(left: 10),
                                    isExpanded: true,
                                    borderRadius: BorderRadius.circular(1.r),
                                    value: selectedYear,
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    items: years.map((year) {
                                      return DropdownMenuItem(
                                        value: year,
                                        child: Text(year),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() => selectedYear = value);
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 18),
                          Text(
                            "Gender",
                            style: AppTextStyles.textStyle16.copyWith(
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.3,
                              color: AppColor.black,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: RadioListTile(
                                  value: "male",
                                  title: Text("Male"),
                                  groupValue: selectedGender,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedGender = value!;
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                child: RadioListTile(
                                  title: const Text('Female'),
                                  value: "femal",
                                  groupValue: selectedGender,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedGender = value!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
