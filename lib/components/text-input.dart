import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String title;
  final int questionId; // New parameter for questionId
  final String? initialValue; // New optional parameter for initial value
  final TextStyle hintStyle;
  final TextStyle textStyle;
  final BorderRadius borderRadius;
  final Color backgroundColor;
  final ValueChanged<Map<String, dynamic>>?
      onTextChanged; // Updated callback type

  const TextInputField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.title,
    required this.questionId, // Required questionId parameter
    this.initialValue, // Optional initialValue parameter
    this.hintStyle =
        const TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
    this.textStyle = const TextStyle(fontSize: 14.0),
    this.borderRadius =
        const BorderRadius.all(Radius.circular(7.0)), // Default radius
    this.backgroundColor = Colors.white, // Default value
    this.onTextChanged, // Optional callback
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // If an initialValue is provided, set it in the controller
    if (initialValue != null && controller.text.isEmpty) {
      controller.text = initialValue!;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            title,
            style: GoogleFonts.montserrat(
              textStyle: const TextStyle(
                fontSize: 24.0, // Default title font size
                fontWeight: FontWeight.bold, // Default font weight
                color: Colors.black, // Default font color
              ),
            ), // Apply title style
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: borderRadius,
          ),
          child: Align(
            alignment: Alignment.topLeft, // Aligns the text to the top-left
            child: TextField(
              controller: controller,
              textAlign: TextAlign.left, // Align text to the left
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: hintStyle,
                border: InputBorder.none, // Remove borders
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical:
                      16.0, // Adjust padding to make the input area taller
                ),
              ),
              style: textStyle,
              onChanged: (text) {
                if (onTextChanged != null) {
                  onTextChanged!({
                    "question": questionId,
                    "answer": {
                      "answer": text,
                    },
                  }); // Emit the structured data
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
