import 'package:flutter/material.dart';

class miniText extends StatelessWidget {
  const miniText({
    super.key, required this.constraints, required this.txt,
  });
  final BoxConstraints constraints;
  final String txt;
  @override
  Widget build(BuildContext context) {
    return Text(
txt,
      
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: constraints.maxWidth * 0.04,
        color: Colors.grey,
      ),
    );
  }
}