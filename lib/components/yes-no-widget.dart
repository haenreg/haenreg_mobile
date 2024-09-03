import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class YesNoWidget extends StatefulWidget {
  final String? selectedOption; // Made optional by changing to String?
  final int questionId; // ID for the question related to the yes/no answer
  final String title; // Title of the question
  final String description; // Description of the question
  final ValueChanged<Map<String, dynamic>>
      onOptionChanged; // Updated callback type

  YesNoWidget({
    this.selectedOption, // No longer required
    required this.questionId,
    required this.title,
    required this.description,
    required this.onOptionChanged,
  });

  @override
  _YesNoWidgetState createState() => _YesNoWidgetState();
}

class _YesNoWidgetState extends State<YesNoWidget> {
  String? _selectedOption;

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.selectedOption; // Initialize the selected option
  }

  void _handleOptionChange(String? value) {
    if (value != null) {
      setState(() {
        _selectedOption = value; // Update the selected option state
      });
      widget.onOptionChanged({
        "question": widget.questionId,
        "answer": {"answer": value},
      }); // Emit structured data
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: GoogleFonts.montserrat(
            textStyle: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(
            height: 8.0), // Add spacing between title and description
        Text(
          widget.description,
          style: GoogleFonts.montserrat(
            textStyle: const TextStyle(
              fontSize: 18.0,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(
            height: 16.0), // Add spacing between description and options
        Row(
          children: [
            Expanded(
              child: ListTile(
                title: const Text('Ja'),
                leading: Radio<String>(
                  value: 'YES',
                  groupValue: _selectedOption,
                  onChanged: _handleOptionChange,
                ),
                onTap: () => _handleOptionChange('YES'), // Handle tap on text
              ),
            ),
            Expanded(
              child: ListTile(
                title: const Text('Nej'),
                leading: Radio<String>(
                  value: 'NO',
                  groupValue: _selectedOption,
                  onChanged: _handleOptionChange,
                ),
                onTap: () => _handleOptionChange('NO'), // Handle tap on text
              ),
            ),
          ],
        ),
      ],
    );
  }
}
