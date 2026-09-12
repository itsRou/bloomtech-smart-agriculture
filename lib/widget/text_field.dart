import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final Icon? suffixIcon;
  final TextEditingController? controller;
 final Color? iconColor ;
   CustomTextField({super.key, this.suffixIcon , this.controller , this.iconColor});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return  Container(
      width: 200,
      height: 50,
      decoration:BoxDecoration(
        color: Color(0xffE9EDDE),
        borderRadius: BorderRadius.circular(20)
      ),
      child: TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          border: InputBorder.none,
        suffixIcon: widget.suffixIcon,
        suffixIconColor: widget.iconColor
        )
      ),
    );
  }
}