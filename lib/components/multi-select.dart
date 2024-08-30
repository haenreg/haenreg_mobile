import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MultiSelect extends StatefulWidget {
  final int questionId;
  final String title;
  final String description;
  final List<Map<String, dynamic>> choices;
  final Function(Map<String, dynamic>) onSelected; // Callback to parent
  final List<int>?
      initialSelectedChoicesIds; // New property for initial selections

  const MultiSelect({
    super.key,
    required this.questionId,
    required this.title,
    required this.description,
    required this.choices,
    required this.onSelected,
    this.initialSelectedChoicesIds, // Optional, if no initial selection is needed
  });

  @override
  _MultiSelectState createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  List<int> _selectedChoicesIds =
      []; // State variable to track selected choices

  @override
  void initState() {
    super.initState();
    // Set the initial selected choices if provided by the parent
    if (widget.initialSelectedChoicesIds != null) {
      _selectedChoicesIds = List.from(widget.initialSelectedChoicesIds!);
    }
  }

  void _onCheckboxSelected(bool? selected, int choiceId) {
    setState(() {
      if (selected == true) {
        _selectedChoicesIds.add(choiceId); // Add choice if selected
      } else {
        _selectedChoicesIds.remove(choiceId); // Remove choice if deselected
      }
    });

    // Send the selected choices back to the parent component
    widget.onSelected({
      "question": widget.questionId,
      "answer": {"choice": _selectedChoicesIds}
    });
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
          return CheckboxListTile(
            title: Text(
              choice['choice'],
              style: GoogleFonts.montserrat(
                textStyle: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),
            ),
            value: _selectedChoicesIds.contains(choice['id']),
            onChanged: (bool? value) {
              _onCheckboxSelected(value, choice['id']); // Handle selection
            },
            controlAffinity:
                ListTileControlAffinity.leading, // Checkbox on the left side
          );
        }).toList(),
        const SizedBox(height: 16),
      ],
    );
  }
}
