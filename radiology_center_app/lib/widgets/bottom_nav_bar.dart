import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:radiology_center_app/core/constant/app_color.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildHomeIcon(0),
          _buildIcon("appointment.svg", 1),
          _buildPlusButton(),
          _buildIcon("chat.svg", 2),
          _buildIcon("profile.svg", 3),
        ],
      ),
    );
  }

  Widget _buildHomeIcon(int index) {
    final bool isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Icon(
        Icons.home,
        size: 24,
        color: isSelected ? const Color(0xFF183E78) : white,
      ),
    );
  }

  Widget _buildIcon(String assetName, int index) {
    final bool isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: SvgPicture.asset(
        'assets/icons/$assetName',
        width: 24,
        height: 24,
        colorFilter: ColorFilter.mode(
          isSelected ? const Color(0xFF183E78) : grey,
          BlendMode.srcIn,
        ),
      ),
    );
  }

  Widget _buildPlusButton() {
    return Transform.translate(
      offset: const Offset(0, -10),
      child: Container(
        width: 48,
        height: 48,
        decoration: const BoxDecoration(
          color: Color(0xFF183E78),
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: Icon(Icons.add, color: Colors.white, size: 28),
        ),
      ),
    );
  }
}
