import 'package:flutter/material.dart';

Widget buildBottomNavIcon(IconData icon,
    {bool isSelected = false, bool isSmallScreen = false}) {
  return IconButton(
    icon: Icon(
      icon,
      size: isSmallScreen ? 36 : 48,
      color: isSelected ? Colors.green.shade800 : Colors.green.shade300,
    ),
    onPressed: () {
      // Handle bottom nav icon action
    },
  );
}