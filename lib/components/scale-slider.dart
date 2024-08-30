import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RatingSlider extends StatefulWidget {
  final int initialRating; // Initial rating value
  final int questionId; // ID for the question related to the rating
  final String title; // Title of the question
  final String description; // Description of the question

  const RatingSlider({
    Key? key,
    this.initialRating = 1,
    required this.questionId,
    required this.title,
    required this.description, // New description parameter
    required this.onRatingChanged,
  }) : super(key: key);

  final ValueChanged<Map<String, dynamic>>
      onRatingChanged; // Updated callback type

  @override
  _RatingSliderState createState() => _RatingSliderState();
}

class _RatingSliderState extends State<RatingSlider> {
  late double _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating.toDouble(); // Initialize rating
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.title, // Display the title
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
          widget.description, // Display the description
          style: GoogleFonts.montserrat(
            textStyle: const TextStyle(
              fontSize: 18.0,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(
            height: 16.0), // Add spacing between description and slider
        Slider(
          value: _currentRating,
          min: 1.0,
          max: 10.0,
          divisions: 9,
          label: _currentRating.round().toString(),
          onChanged: (value) {
            setState(() {
              _currentRating = value;
            });
            widget.onRatingChanged({
              "question": widget.questionId,
              "answer": {
                "answer": _currentRating.round(),
              },
            }); // Emit structured data
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(10, (index) => index + 1).map((number) {
            return Expanded(
              child: Text(
                number.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14.0),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
