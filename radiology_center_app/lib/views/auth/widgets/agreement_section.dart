import 'package:flutter/material.dart';
import 'package:radiology_center_app/core/constant/app_color.dart';
import 'package:radiology_center_app/core/constant/text_style.dart';

class Agreementsection extends StatelessWidget {
 final bool ischecked ;
final void Function(bool?)? onChanged;
  const Agreementsection({super.key, required this.ischecked,required this.onChanged,});


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(
          splashRadius: 16,
          value: ischecked,
          onChanged:onChanged,
          activeColor: subtitleColor,
          side: BorderSide.none,
          shape: CircleBorder(),
          fillColor: WidgetStateColor.resolveWith((states) {
            return subtitleColor;
          }),
        ),
        Text(
          "I agree with the Terms of Service & Privacy Policy",
          style: AppTextStyles.textStyle12.copyWith(
            color: subtitleColor,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }
}
//  (value) {

//           },