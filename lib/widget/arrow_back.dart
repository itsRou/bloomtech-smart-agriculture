import 'package:flutter/material.dart';

class arrowBack extends StatelessWidget {
  const arrowBack({
    super.key,
    required this.constraints, required this.onPressed,
  });
  final BoxConstraints constraints;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: constraints.maxHeight * 0.06,
      left: constraints.maxWidth * 0.06,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFFDAE5DD),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF194E19)),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
