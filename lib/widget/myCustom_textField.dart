import 'package:flutter/material.dart';

class customTextField extends StatelessWidget {
  const customTextField({
    super.key,
    required this.hintTxt,
    required this.prefixIcon,
    required this.suffixIcon,
  });
  final String hintTxt;
  final Widget prefixIcon;
  final Widget suffixIcon;
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        hintText: hintTxt,
        filled: true,
        fillColor: Color(0xFF194E19).withOpacity( 0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: (value) {
        print("Email input changed: $value");
      },
    );
  }
}
