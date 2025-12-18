import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radiology_center_app/core/constant/app_color.dart';
import 'package:radiology_center_app/core/constant/text_style.dart';

class ScrollableOptions extends StatelessWidget {
  final List<String> items;
  final int selectedIndex;
  final Function(int) onSelect;

  const ScrollableOptions({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: items.length,
        separatorBuilder: (_, __) => SizedBox(width: 12.w),
        itemBuilder: (context, index) {
          final bool isSelected = index == selectedIndex;
          return GestureDetector(
            onTap: () => onSelect(index),
            child: Container(
              width: 60.w,
              height: 60.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? buttonBackground : const Color(0x140EBE7F),
              ),
              child: Text(
                items[index],
                textAlign: TextAlign.center,
                style: AppTextStyles.textStyle14.copyWith(
                  fontSize: 14.sp,
                  color: isSelected ? Colors.white : buttonBackground,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
