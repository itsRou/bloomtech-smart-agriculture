import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildFilterButton(String label,
    {bool isSelected = false, bool isSmallScreen = false}) {
  return Padding(
    padding:  EdgeInsets.symmetric(horizontal: 12.0),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: isSelected ? 4 : 0,
        backgroundColor: isSelected ? Color(0xFF194E19) : Colors.green.shade200,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(61),
        ),
        minimumSize: isSmallScreen ? const Size(90, 60) : const Size(100, 40),
      ),
      onPressed: () {
        // Handle filter button press
      },
      child: Text(
        label,
        style: GoogleFonts.k2d(
          fontSize: isSmallScreen ? 18 : 20,
          color: isSelected ? Colors.white : Colors.green.shade800,
        ),
      ),
    ),
  );
}


