import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectOne extends StatefulWidget {
  final int questionId;
  final String title;
  final String description;
  final List<Map<String, dynamic>> choices;
  final Function(Map<String, dynamic>) onSelected; // Callback to parent
  final int? initialSelectedChoiceId; // New property for initial selection

  const SelectOne({
    super.key,
    required this.questionId,
    required this.title,
    required this.description,
    required this.choices,
    required this.onSelected,
    this.initialSelectedChoiceId, // Optional, if no initial selection is needed
  });

  @override
  _SelectOneState createState() => _SelectOneState();
}

class _SelectOneState extends State<SelectOne> {
  int? _selectedChoiceId; // State variable to track the selected choice

  @override
  void initState() {
    super.initState();
    // Set the initial selected choice if provided by the parent
    _selectedChoiceId = widget.initialSelectedChoiceId;
  }

  void _onRadioSelected(int choiceId) {
    setState(() {
      _selectedChoiceId = choiceId; // Update the selected choice
    });

    // Send the selected choice back to the parent component
    widget.onSelected({
      "question": widget.questionId,
      "answer": {
        "choice": [choiceId]
      }
    });
  }

  @override
  void didUpdateWidget(covariant SelectOne oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialSelectedChoiceId != oldWidget.initialSelectedChoiceId) {
      setState(() {
        _selectedChoiceId =
            widget.initialSelectedChoiceId; // Update when the prop changes
      });
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
        const SizedBox(height: 8),
        Text(
          widget.description,
          style: GoogleFonts.montserrat(
            textStyle: const TextStyle(
              fontSize: 18.0,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 8),
        ...widget.choices.map((choice) {
          return RadioListTile(
            title: Text(
              choice['choice'],
              style: GoogleFonts.montserrat(
                textStyle: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),
            ),
            value: choice['id'],
            groupValue: _selectedChoiceId, // Bind to the state variable
            onChanged: (value) {
              _onRadioSelected(choice['id']); // Handle selection
            },
          );
        }).toList(),
        const SizedBox(height: 16),
      ],
    );
  }
}
