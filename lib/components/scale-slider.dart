import 'package:flutter/material.dart';

class RatingSlider extends StatefulWidget {
  final int initialRating;
  final ValueChanged<int> onRatingChanged;

  const RatingSlider({
    Key? key,
    this.initialRating = 1,
    required this.onRatingChanged,
  }) : super(key: key);

  @override
  _RatingSliderState createState() => _RatingSliderState();
}

class _RatingSliderState extends State<RatingSlider> {
  late double _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Slider(
          value: _currentRating,
          min: 1.0,
          max: 10.0,
          divisions: 9, // To create discrete steps of 1 unit
          label: _currentRating.round().toString(),
          onChanged: (value) {
            setState(() {
              _currentRating = value;
              widget.onRatingChanged(_currentRating.round());
            });
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
