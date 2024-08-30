import 'package:flutter/material.dart';
import 'package:haenreg_mobile/components/multi-select.dart';
import 'package:haenreg_mobile/components/select-one.dart';
import 'package:haenreg_mobile/services/http-service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:haenreg_mobile/components/custom-top-bar.dart';
import 'package:haenreg_mobile/components/text-input.dart';
import 'package:haenreg_mobile/components/yes-no-widget.dart';
import 'package:haenreg_mobile/components/scale-slider.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final HttpService _httpService = HttpService();
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  String _selectedOption = 'Ja';
  int _rating = 1; // Default rating
  List<dynamic> _questions = [];
  bool isLoading = true;
  List<Widget> questionWidgets = [];

  @override
  void initState() {
    super.initState();
    _fetchData(); // Fetch data when the widget is initialized
  }

  Future<void> _fetchData() async {
    try {
      final response = await _httpService.get('/questions/get-questions');

      if (response.statusCode == 200) {
        final List<dynamic> questions = jsonDecode(response.body);

        setState(() {
          questionWidgets = questions.map<Widget>((question) {
            switch (question['type']) {
              case 'SELECT_ONE':
                return SelectOne(
                  questionId: question['id'],
                  title: question['title'],
                  description: question['description'],
                  choices: List<Map<String, dynamic>>.from(
                    question['questionChoices'],
                  ),
                  onSelected: (selectedData) {
                    print("Selected Data: $selectedData");
                    // Handle the submitted data here
                    // For example, you could send it to an API or update your state
                  },
                );
              case 'MULTI_SELECT':
                return MultiSelect(
                  questionId: question['id'],
                  title: question['title'],
                  description: question['description'],
                  choices: List<Map<String, dynamic>>.from(
                    question['questionChoices'],
                  ),
                  onSelected: (selectedData) {
                    print("Selected Data: $selectedData");
                  },
                );
              case 'TEXT':
                return TextInputField(
                  questionId: question['id'],
                  controller: _textController,
                  title: question['title'],
                  hintText: question['description'],
                  hintStyle: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 14.0,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                  onTextChanged: (text) {
                    print('Text changed: $text');
                  },
                );
              case 'SCALE':
                return RatingSlider(
                  questionId: question['id'],
                  title: question['title'],
                  description: question['description'],
                  onRatingChanged: (rating) {
                    print('Text changed: $rating');
                  },
                );
              case 'YES_NO':
                return YesNoWidget(
                  selectedOption: 'NO',
                  questionId: question['id'],
                  title: question['title'],
                  description: question['description'],
                  onOptionChanged: (newValue) {
                    print('YES_NO changed: $newValue');
                  },
                );
              default:
                return Container(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Unsupported question type: ${question['type']}',
                    style: TextStyle(color: Colors.red),
                  ),
                );
            }
          }).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          questionWidgets = [];
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        questionWidgets = [];
        isLoading = false;
      });
    }
  }

  List<dynamic> _ensureRequiredItems(List<dynamic> data) {
    final List<dynamic> updatedData = List.from(data);

    // Flags to check if required items are present
    bool hasScale = false;
    bool hasBoolean = false;

    // Check existing data for SCALE and BOOLEAN items
    for (var item in data) {
      if (item['type'] == 'SCALE') {
        hasScale = true;
      } else if (item['type'] == 'BOOLEAN') {
        hasBoolean = true;
      }
    }

    // Define the mock items
    final scaleItem = {
      "id": 900,
      "title": "Scale",
      "description": "Scale",
      "type": "SCALE",
      "questionChoices": []
    };

    final booleanItem = {
      "id": 901,
      "title": "Boolean",
      "description": "Boolean",
      "type": "BOOLEAN",
      "questionChoices": []
    };

    // Add missing items
    if (!hasScale) {
      updatedData.add(scaleItem);
    }
    if (!hasBoolean) {
      updatedData.add(booleanItem);
    }

    return updatedData;
  }

  Future<void> _handleSubmit() async {
    String inputText = _textController.text;

    if (inputText.isNotEmpty) {
      final url = Uri.parse(
          'http://10.0.2.2:3000/api/cases/create-new-case'); // Update to your correct endpoint

      debugPrint(_rating.toString());
      print(inputText);

      try {
        return;
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode([
            {
              'id': 1, // Example question ID for text input
              'title': 'Text Input Title', // Hardcoded title
              'description': 'Description of the text input',
              'type': 'TEXT', // Hardcoded type for text input
              'questionChoices': [], // No choices for text input
              'answer': {
                'answer': inputText // Include the text input
              },
            },
            {
              'id': 5, // Example question ID for rating slider
              'title': 'Rate this question', // Hardcoded title
              'description':
                  'Rate the level on a scale', // Hardcoded description
              'type': 'SCALE', // Hardcoded type for slider
              'questionChoices': [], // No choices for scale slider
              'answer': {
                'choice': _rating // Rating value
              },
            }
          ]),
        );

        if (response.statusCode == 200) {
          debugPrint(
              'Data inserted into database: Text: $inputText, Rating: $_rating');
        } else {
          debugPrint('Error inserting data: ${response.body}');
        }
      } catch (error) {
        debugPrint('An error occurred test: $error');
      }
    } else {
      debugPrint('Text field is empty');
    }
  }

  void _onRatingChanged(int rating) {
    setState(() {
      _rating = rating;
    });
  }

  /* @override
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
              questionId: 888,
              title: 'hello',
              controller: _textController,
              hintText: 'Skriv text her...',
              hintStyle: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.normal,
              ),
              textStyle: const TextStyle(
                fontSize: 14.0,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            const SizedBox(height: 16.0),
            YesNoWidget(
              selectedOption: _selectedOption,
              questionId: 888,
              title: 'title',
              description: 'description',
              onOptionChanged: (newValue) {
                print('Yes No Changed: $newValue');
              },
            ),
            const SizedBox(height: 16.0),
            RatingSlider(
              initialRating: _rating,
              questionId: 5, // Example question ID for slider
              title: 'Din reaktion', // Hardcoded title
              description: 'På en skala fra 1-10', // Hardcoded title
              onRatingChanged: (rating) {
                print('Text changed: $rating');
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _handleSubmit,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  } */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomTopBar(
        isEditMode: true,
        editButtonText: 'Gem',
        onEdit: () {
          print('Edit button clicked');
        },
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : ListView.builder(
                itemCount: questionWidgets.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, // Side padding
                      vertical:
                          8.0, // Vertical padding for spacing between items
                    ),
                    child: questionWidgets[index],
                  );
                },
              ),
      ),
    );
  }
}
