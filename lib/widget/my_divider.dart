import 'package:flutter/material.dart';

class myDivider extends StatelessWidget {
  const myDivider({
    super.key, required this.constraints,
  });
    final BoxConstraints constraints;


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: Colors.grey,
            thickness: 1,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: constraints.maxWidth * 0.02),
          child: Text(
            'Or continue with',
            style: TextStyle(
              fontSize: constraints.maxWidth * 0.04,
              color: Color(0xFF194E19),
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: Colors.grey,
            thickness: 1,
          ),
        ),
      ],
    );
  }
}

