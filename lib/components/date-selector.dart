import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DateTimePicker extends StatefulWidget {
  final Function(Map<String,dynamic>) onDateTimeChanged; // Callback to parent

  final int questionId;
  final String title;
  final String description;
  final String? initialValue;

  const DateTimePicker({
    Key? key,
    required this.questionId,
    required this.title,
    required this.description,
    required this.onDateTimeChanged,
    this.initialValue,
  }) : super(key: key);

  @override
  _DateTimePickerState createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  late DateTime _selectedDateTime;

  // Formatters for date and time
  final DateFormat _dateFormatter = DateFormat('dd / MMM / yyyy');
  final DateFormat _timeFormatter = DateFormat('HH : mm');

  @override
  void initState() {
    super.initState();
    // Initialize _selectedDateTime based on initialValue
    if (widget.initialValue != null) {
      _selectedDateTime = DateTime.parse(widget.initialValue!);
    } else {
      _selectedDateTime = DateTime.now();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime firstDate =
        DateTime(now.year, 1, 1); // Start fra 1. januar i år
    final DateTime lastDate =
        now; // Slutter ved dagens dato (forhindrer valg af fremtidige datoer)

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (picked != null && picked != _selectedDateTime) {
      setState(() {
        _selectedDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _selectedDateTime.hour,
          _selectedDateTime.minute,
        );
        widget.onDateTimeChanged({
          "question": widget.questionId,
          "answer": {"answer": _selectedDateTime.toIso8601String()}
        });
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
    );
    if (picked != null) {
      setState(() {
        _selectedDateTime = DateTime(
          _selectedDateTime.year,
          _selectedDateTime.month,
          _selectedDateTime.day,
          picked.hour,
          picked.minute,
        );
        widget.onDateTimeChanged({
          "question": widget.questionId,
          "answer": {"answer": _selectedDateTime.toIso8601String()}
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
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
        // Description
        Text(
          widget.description,
          style: GoogleFonts.montserrat(
            textStyle: const TextStyle(
              fontSize: 18.0,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Date and Time Row
        Row(
          children: [
            Expanded(
              flex: 2, // Date box will take twice as much space
              child: GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _dateFormatter.format(_selectedDateTime),
                    style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 1, // Time box will take half the space of the date box
              child: GestureDetector(
                onTap: () => _selectTime(context),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _timeFormatter.format(_selectedDateTime),
                    style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}