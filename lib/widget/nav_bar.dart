import 'package:flutter/material.dart';

  Widget navBarIcon(IconData icon,
      {bool isSelected = false, bool isSmallScreen = false}) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFC3DEA9) : Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: isSelected ? Colors.green.shade800 : Colors.white,
        size: isSmallScreen ? 24 : 30,
      ),
    );
  }
