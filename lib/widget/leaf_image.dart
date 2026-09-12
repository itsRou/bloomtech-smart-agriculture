import 'package:flutter/material.dart';

class leafImage extends StatelessWidget {
  const leafImage({
    super.key, required this.constraints,
  });
final BoxConstraints constraints; 
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      right: 0,
      child: Image.asset(
        'assets/images/tree.png',
        height: constraints.maxHeight * 0.3,
      ),
    );
  }
}