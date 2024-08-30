import 'package:flutter/material.dart';

class RatingSlider extends StatefulWidget {
  final int initialRating; // Initial rating value
  final int questionId; // ID for the question related to the rating
  final String title; // Title of the question

  const RatingSlider({
    Key? key,
    this.initialRating = 1,
    required this.questionId,
    required this.title,
    required this.onRatingChanged,
  }) : super(key: key);

  final ValueChanged<int> onRatingChanged;

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
          style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
        ),
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
            widget.onRatingChanged(_currentRating.round());
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
