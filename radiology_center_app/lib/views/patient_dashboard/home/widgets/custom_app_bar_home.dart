import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget leftWidget;

  const CustomAppBar({
    super.key,
    required this.leftWidget,
    required String title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [SizedBox(width: 42, height: 42, child: leftWidget)],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(66);
}
