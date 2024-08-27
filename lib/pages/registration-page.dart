import 'package:flutter/material.dart';
import 'package:haenreg_mobile/components/yes-no-widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:haenreg_mobile/components/custom-top-bar.dart';
import 'package:haenreg_mobile/components/text-input.dart'; 
import 'package:haenreg_mobile/components/yes-no-widget.dart';
import 'package:haenreg_mobile/components/scale-slider.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _textController = TextEditingController();
  String _selectedOption = 'Ja';
  int _rating = 1; // Default rating

  Future<void> _handleSubmit() async {
    String inputText = _textController.text;

    if (inputText.isNotEmpty) {
      final url = Uri.parse('http://10.0.2.2:3000/api/questions/get-questions');

      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'questionChoices': [inputText],
            'selectedOption': _selectedOption,
            'rating': _rating,
          }),
        );

        if (response.statusCode == 200) {
          debugPrint('Tekst og valg indsat i databasen: $inputText, $_selectedOption');
        } else {
          debugPrint('Fejl ved indsættelse: ${response.body}');
        }
      } catch (error) {
        debugPrint('En fejl opstod: $error');
      }
    } else {
      debugPrint('Tekstfeltet er tomt');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomTopBar(
        isEditMode: true,
        onEdit: () {},
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextInputField(
              controller: _textController,
              hintText: 'Indtast tekst her',
              hintStyle: const TextStyle(
                fontSize: 14.0, // Skriftstørrelse for hint-tekst
                fontWeight: FontWeight.normal, // Hint-tekst skal ikke være fed
              ),
              textStyle: const TextStyle(
                fontSize: 14.0, // Skriftstørrelse for den indtastede tekst
              ),
              borderRadius: BorderRadius.circular(12.0), // Border-radius
            ),
            const SizedBox(height: 16.0),
            YesNoWidget(
              selectedOption: _selectedOption,
              onOptionChanged: (String newValue) {
                setState(() {
                  _selectedOption = newValue;
                });
              },
            ),
            const SizedBox(height: 16.0),
            RatingSlider(
              initialRating: _rating,
              onRatingChanged: (rating) {
                setState(() {
                  _rating = rating;
                }); 
              },
            ),
          ],
        ),
      ),
    );
  }
}
