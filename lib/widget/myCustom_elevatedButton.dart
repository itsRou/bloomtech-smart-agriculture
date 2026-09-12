import 'package:flutter/material.dart';

class customElevatedButton extends StatelessWidget {
  const customElevatedButton({
    super.key,
    required this.constraints,
    required this.txt,
    required this.onPressed
  });
  final VoidCallback onPressed;
  final BoxConstraints constraints;
  final String txt;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF40744D),
        padding: EdgeInsets.symmetric(
          horizontal: constraints.maxWidth * 0.2,
          vertical: constraints.maxHeight * 0.02,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      child: Text(
        txt,
        style: TextStyle(
          fontSize: constraints.maxWidth * 0.045,
          color: Colors.white,
        ),
      ),
    );
  }
}
