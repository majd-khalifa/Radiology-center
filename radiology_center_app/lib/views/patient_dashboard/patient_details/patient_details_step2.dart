import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radiology_center_app/core/constant/app_color.dart';
import 'package:radiology_center_app/core/constant/app_route.dart';
import 'package:radiology_center_app/core/constant/constant.dart';
import 'package:radiology_center_app/core/constant/text_style.dart';
import 'package:radiology_center_app/core/helper/snack_bar_helper.dart';
import 'package:radiology_center_app/core/services/api/api_services.dart';
import 'package:radiology_center_app/core/widgets/background_image.dart';
import 'package:radiology_center_app/core/widgets/custom_app_bar.dart';
import 'package:radiology_center_app/core/widgets/green_button.dart';
import 'package:radiology_center_app/models/patient_profile_model.dart';
import 'package:radiology_center_app/views/auth/widgets/my_text_field.dart';
import 'package:radiology_center_app/views/patient_dashboard/patient_details/widgets/custom_progress_bar.dart';
import 'package:radiology_center_app/views/patient_dashboard/patient_details/widgets/custom_text.dart';

class PatientDetailsStep2 extends StatefulWidget {
  final PatientProfileModel profile;
  const PatientDetailsStep2({super.key, required this.profile});

  @override
  State<PatientDetailsStep2> createState() => _PatientDetailsStep2State();
}

class _PatientDetailsStep2State extends State<PatientDetailsStep2> {
  final _formKey = GlobalKey<FormState>();
  final ApiServices api = ApiServices();
  final locationController = TextEditingController();
  final descriptionController = TextEditingController();
  File? selectedImage;
  final ImagePicker picker = ImagePicker();
  Future<void> pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
        widget.profile.profileImageFile = selectedImage; // 🔥 المهم
      });
    }
  }

  @override
  void dispose() {
    locationController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Backgroundimage(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                CustomAppBar(title: "PatientDetails"),
                SizedBox(height: 24.h),

                /// Step indicator
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
                          "Step 2/2",
                          style: AppTextStyles.textStyle14.copyWith(
                            color: AppColor.black,
                          ),
                        ),
                        const SizedBox(width: 15),
                        const Expanded(child: CustomProgressBar(progress: 1)),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 24.h),
                const CustomText(text: "Profile Image"),
                SizedBox(height: 8.h),

                Center(
                  child: GestureDetector(
                    onTap: pickImage,
                    child: CircleAvatar(
                      radius: 48.r,
                      backgroundColor: AppColor.grey.withOpacity(0.2),
                      backgroundImage: selectedImage != null
                          ? FileImage(selectedImage!)
                          : widget.profile.profileImageUrl != null
                          ? NetworkImage(widget.profile.profileImageUrl!)
                                as ImageProvider
                          : null,
                      child:
                          selectedImage == null &&
                              widget.profile.profileImageUrl == null
                          ? Icon(
                              Icons.camera_alt,
                              size: 28.sp,
                              color: AppColor.grey,
                            )
                          : null,
                    ),
                  ),
                ),

                SizedBox(height: 20.h),

                /// Card
                Container(
                  width: 1.sw,
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CustomText(text: "Location"),
                            SizedBox(height: 8.h),
                            Mytextfield(
                              text: "Damascus, Syria",
                              controller: locationController,
                              validator: (String? p1) {
                                return null;
                              },
                            ),

                            SizedBox(height: 20.h),

                            const CustomText(text: "Medical Description"),
                            SizedBox(height: 8.h),
                            Mytextfield(
                              text: "Patient suffers from back pain",
                              controller: descriptionController,
                              validator: (String? p1) {
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 32.h),

                /// Continue button
                GreenButton(
                  widget: Text(
                    "Continue",
                    style: AppTextStyles.textStyle18.copyWith(
                      color: AppColor.white,
                    ),
                  ),
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;

                    widget.profile.description = descriptionController.text;
                    widget.profile.location = locationController.text;

                    try {
                      await api.createOrUpdateProfileMultipart(
                        profile: widget.profile,
                        token:
                           ConstantData.tokenValue, // نفس التوكن
                      );

                      SnackBarHelper.showSuccess(
                        context,
                        "Profile completed successfully",
                      );

                      Navigator.pushReplacementNamed(context, AppRoute.home);
                    } catch (e) {
                      SnackBarHelper.showError(context, e.toString());
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
