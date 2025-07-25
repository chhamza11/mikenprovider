// lib/modules/home/widgets/bottom_navbar.dart

import 'package:flutter/material.dart';
// Make sure this path is correct for your project
import '../../../../constants/app_colors.dart';

class BottomNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // A container with a subtle shadow and background color from your theme
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavbarItem(
              icon: Icons.home_filled,
              label: 'Home',
              index: 0,
              currentIndex: currentIndex,
              onTap: onTap,
            ),
            _NavbarItem(
              icon: Icons.list_alt_outlined,
              label: 'My Listings',
              index: 1,
              currentIndex: currentIndex,
              onTap: onTap,
            ),
            _NavbarItem(
              icon: Icons.chat_bubble_outline_rounded,
              label: 'Chat',
              index: 2,
              currentIndex: currentIndex,
              onTap: onTap,
            ),
            _NavbarItem(
              icon: Icons.settings_outlined,
              label: 'Settings',
              index: 3,
              currentIndex: currentIndex,
              onTap: onTap,
            ),
          ],
        ),
      ),
    );
  }
}

// A private helper widget for each navigation item
class _NavbarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int currentIndex;
  final Function(int) onTap;

  const _NavbarItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Check if this item is currently selected
    final bool isSelected = index == currentIndex;
    // Set color based on selection status, using your theme colors
    final Color color = isSelected ? AppColors.primaryOrange : AppColors.lightGray;

    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        // Removes the splash effect for a cleaner look
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min, // Important for vertical alignment
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}