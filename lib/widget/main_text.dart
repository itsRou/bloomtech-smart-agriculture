import 'package:flutter/material.dart';

class mainText extends StatelessWidget {
  const mainText({
    super.key,
    required this.txt,
    required this.constraints,
  });
  final String txt;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    return Text(
      txt,
      style: TextStyle(
        fontSize: constraints.maxWidth * 0.095,
        fontWeight: FontWeight.bold,
        color: Color(0xFF194E19),
      ),
    );
  }
}
