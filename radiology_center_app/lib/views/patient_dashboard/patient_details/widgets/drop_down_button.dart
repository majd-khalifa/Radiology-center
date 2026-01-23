import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radiology_center_app/core/constant/app_color.dart';
import 'package:radiology_center_app/core/constant/text_style.dart';

class DropDownButton extends StatelessWidget {
  const DropDownButton({
    super.key,

    required this.selectedItem,
    required this.onChanged,
    required this.items,
    required this.item,
  });
  final String item;
  final List<String> items;
  final String? selectedItem;
  final void Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54.h,
      width: 90.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColor.subtitleColor, width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          hint: Text(item),
          padding: EdgeInsets.only(left: 10),
          isExpanded: true,
          borderRadius: BorderRadius.circular(1.r),
          value: items.contains(selectedItem) ? selectedItem : null,

          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item, style: AppTextStyles.textStyle16.copyWith()),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
