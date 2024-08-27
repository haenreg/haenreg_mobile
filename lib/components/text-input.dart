import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextStyle hintStyle;
  final TextStyle textStyle;
  final BorderRadius borderRadius;
  final Color backgroundColor;

  const TextInputField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.hintStyle = const TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
    this.textStyle = const TextStyle(fontSize: 14.0),
    this.borderRadius = const BorderRadius.all(Radius.circular(7.0)), // Default radius
    this.backgroundColor = Colors.white, // Default value
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: hintStyle,
          border: InputBorder.none, // Remove borders
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0), // Adjust padding if needed
        ),
        style: textStyle,
      ),
    );
  }
}
