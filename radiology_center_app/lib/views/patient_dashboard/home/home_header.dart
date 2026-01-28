import 'package:flutter/material.dart';
import 'package:radiology_center_app/core/constant/constant.dart';
import 'package:radiology_center_app/core/constant/text_style.dart';
import 'package:radiology_center_app/core/services/api/api_services.dart';

class DashboardHeader extends StatefulWidget {
  const DashboardHeader({super.key});

  @override
  State<DashboardHeader> createState() => _DashboardHeaderState();
}

class _DashboardHeaderState extends State<DashboardHeader> {
  String userName = "User";
  String? profileImage;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final api = ApiServices();
    final token = ConstantData.tokenValue;

    final profile = await api.getProfile(token);

    setState(() {
      userName = profile["full_name"] ?? "User";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Welcome!", style: AppTextStyles.textStyle32),
                Text(userName, style: AppTextStyles.textStyle32),
                const SizedBox(height: 4),
                Text(
                  "How is it going today?",
                  style: AppTextStyles.textStyle16,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
          const SizedBox(width: 16),
          profileImage != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    profileImage!,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                )
              : Image.asset(
                  'assets/images/doctor.png',
                  width: 188,
                  height: 233,
                  fit: BoxFit.cover,
                ),
        ],
      ),
    );
  }
}
