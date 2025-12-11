import 'package:flutter/material.dart';
import 'package:radiology_center_app/core/constant/app_color.dart';
import 'package:radiology_center_app/core/constant/text_style.dart';
import 'package:radiology_center_app/widgets/category_item.dart';

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            "Our Services",
            style: AppTextStyles.textStyle16.copyWith(color: black),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              CategoryItem("Consultation", 'assets/icons/consultation.svg'),
              CategoryItem("Medicines", 'assets/icons/medicines.svg'),
              CategoryItem("Ambulance", 'assets/icons/ambulance.svg'),
            ],
          ),
        ),
      ],
    );
  }
}
