// ignore_for_file: deprecated_member_use
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radiology_center_app/core/constant/app_color.dart';
import 'package:radiology_center_app/core/constant/app_route.dart';
import 'package:radiology_center_app/core/constant/constant.dart';
import 'package:radiology_center_app/core/constant/text_style.dart';
import 'package:radiology_center_app/core/services/api/api_link.dart';
import 'package:radiology_center_app/core/services/api/api_services.dart';
import 'package:radiology_center_app/core/widgets/green_button.dart';
import 'package:radiology_center_app/core/widgets/text_form_field.dart';
import 'package:radiology_center_app/models/patient_profile_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiServices api = ApiServices();
  DateTime? selectedBirthDate;
  final ImagePicker picker = ImagePicker();
  File? selectedImage;
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController locationController;
  late TextEditingController datecontroller;

  PatientProfileModel? profile;

  Future<void> loadProfile() async {
    final data = await api.getData(
      url: ApiLink.profileSetup,
      token: ConstantData.tokenValue,
    );

    profile = PatientProfileModel.fromJson(data);

    nameController.text = profile!.fullName ?? '';
    phoneController.text = profile!.contactNumber ?? '';
    locationController.text = profile!.location ?? '';
    selectedBirthDate = DateTime(
      int.parse(profile!.birthYear!),
      _monthToNumber(profile!.birthMonth!),
      int.parse(profile!.birthDay!),
    );

    datecontroller.text =
        "${profile!.birthDay}/${profile!.birthMonth}/${profile!.birthYear}";

    setState(() {});
  }

  Future<void> pickProfileImage() async {
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
        profile!.profileImageFile = selectedImage; // 🔥 مهم للرفع
      });
    }
  }

  String get profileImageUrl => "${ApiLink.baseUrl}${profile!.profileImageUrl}";
  int _monthToNumber(String month) {
    const months = {
      "January": 1,
      "February": 2,
      "March": 3,
      "April": 4,
      "May": 5,
      "June": 6,
      "July": 7,
      "August": 8,
      "September": 9,
      "October": 10,
      "November": 11,
      "December": 12,
    };
    return months[month] ?? 1;
  }

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController();
    phoneController = TextEditingController();
    locationController = TextEditingController();
    datecontroller = TextEditingController();

    loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    if (profile == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      body: Stack(
        children: [
          // الخلفية الخضراء العلوية
          Container(
            height: 350.h,
            decoration: BoxDecoration(
              color: AppColor.buttonBackground,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30.r),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildModifiedAppBar(context, "Profile"),

                  SizedBox(height: 20.h),
                  Text(
                    "Set up your profile",
                    style: AppTextStyles.textStyle18.copyWith(
                      color: AppColor.white,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: Text(
                      "Update your profile to connect your doctor with better impression.",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.textStyle14.copyWith(
                        color: AppColor.white.withOpacity(0.8),
                      ),
                    ),
                  ),

                  SizedBox(height: 30.h),
                  _buildProfileImage(),
                  SizedBox(height: 40.h),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Personal information",
                          style: AppTextStyles.textStyle18.copyWith(
                            color: AppColor.black,
                          ),
                        ),
                        SizedBox(height: 10.h),

                        // استخدام الويدجيت المشتركة الجديدة
                        CustomTextFormField(
                          label: "Name",
                          controller: nameController,
                        ),

                        CustomTextFormField(
                          label: "Contact Number",
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                        ),

                        CustomTextFormField(
                          label: "Location",
                          controller: locationController,
                        ),

                        CustomTextFormField(
                          label: "Date of birth",
                          controller: datecontroller,
                          readOnly: true,
                          hasEditIcon: true,
                          onTap: () async {
                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: selectedBirthDate ?? DateTime(2000),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );

                            if (pickedDate != null) {
                              selectedBirthDate = pickedDate;

                              datecontroller.text =
                                  "${pickedDate.day}/${_numberToMonth(pickedDate.month)}/${pickedDate.year}";

                              profile!
                                ..birthDay = pickedDate.day.toString()
                                ..birthMonth = _numberToMonth(pickedDate.month)
                                ..birthYear = pickedDate.year.toString();

                              setState(() {});
                            }
                          },
                        ),

                        SizedBox(height: 40.h),

                        GreenButton(
                          onPressed: () async {
                            profile!
                              ..fullName = nameController.text
                              ..contactNumber = phoneController.text
                              ..location = locationController.text;

                            await api.updateProfile(
                              profile: profile!,
                              token: ConstantData.tokenValue,
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Profile updated successfully"),
                              ),
                            );
                          },
                          widget: Text(
                            "Continue",
                            style: AppTextStyles.textStyle18.copyWith(
                              color: AppColor.white,
                            ),
                          ),
                        ),

                        SizedBox(height: 30.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // (ويدجيت اختيار الصورة والـ AppBar تبقى كما هي أو تنقل لملفات مستقلة أيضاً)
  Widget _buildProfileImage() {
    ImageProvider? imageProvider;

    if (selectedImage != null) {
      imageProvider = FileImage(selectedImage!); // صورة جديدة
    } else if (profile!.profileImageUrl != null &&
        profile!.profileImageUrl!.isNotEmpty) {
      imageProvider = NetworkImage(profileImageUrl); // صورة من السيرفر
    }

    return GestureDetector(
      onTap: pickProfileImage, // 👈 عند الضغط
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 65.r,
            backgroundColor: AppColor.silver,
            backgroundImage: imageProvider,
            child: imageProvider == null
                ? Icon(Icons.person, size: 40.sp)
                : null,
          ),
          CircleAvatar(
            radius: 18.r,
            backgroundColor: AppColor.subtitleColor,
            child: Icon(Icons.camera_alt, color: AppColor.white, size: 18.r),
          ),
        ],
      ),
    );
  }

  Widget _buildModifiedAppBar(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context, AppRoute.home),
            child: Container(
              width: 30.w,
              height: 30.h,
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                size: 15.sp,
                color: AppColor.grey,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Text(
            title,
            style: AppTextStyles.textStyle18.copyWith(color: AppColor.white),
          ),
        ],
      ),
    );
  }

  String _numberToMonth(int month) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return months[month - 1];
  }
}
