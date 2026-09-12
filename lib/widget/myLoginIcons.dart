import 'package:flutter/material.dart';

class myLoginIcons extends StatelessWidget {
  const myLoginIcons({
    super.key,
    required this.iconWidth,
    required this.iconSize, required this.constraints,
  });
    final BoxConstraints constraints;

  final double iconWidth;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: Image.asset(
              'assets/images/facebook.png',
              width: iconWidth,
            ),
            iconSize: iconSize, // Reduced icon size
            onPressed: () {
              print("Facebook login pressed");
            },
          ),
        ),
        SizedBox(width: constraints.maxWidth * 0.05),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: Image.asset(
              'assets/images/google.png',
              width: iconWidth,
            ),
            iconSize: iconSize, // Reduced icon size
            onPressed: () {
              print("Google login pressed");
            },
          ),
        ),
        SizedBox(width: constraints.maxWidth * 0.05),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: Image.asset(
              'assets/images/apple.png',
              width: iconWidth,
            ),
            iconSize: iconSize, // Reduced icon size
            onPressed: () {
              print("Apple login pressed");
            },
          ),
        ),
      ],
    );
  }
}

