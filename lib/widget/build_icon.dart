import 'package:flutter/material.dart';

Widget buildIconButton(
      IconData icon, VoidCallback onPressed) {
    // notification and search icons in the top
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFC3DEA9),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: Color(0xff194E19)),
        iconSize: 30,
        onPressed: onPressed,
      ),
    );
  }