import 'package:flutter/material.dart';
import 'package:haenreg_mobile/components/date-selector.dart';
import 'package:haenreg_mobile/components/multi-select.dart';
import 'package:haenreg_mobile/components/select-one.dart';
import 'package:haenreg_mobile/services/http-service.dart';
import 'dart:convert';
import 'package:haenreg_mobile/components/custom-top-bar.dart';
import 'package:haenreg_mobile/components/text-input.dart';
import 'package:haenreg_mobile/components/yes-no-widget.dart';
import 'package:haenreg_mobile/components/scale-slider.dart';
import 'package:http/http.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final HttpService _httpService = HttpService();
  final TextEditingController _textController = TextEditingController();
  bool isLoading = true;
  List<Widget> questionWidgets = [];
  List<Map<String, dynamic>> answers = [];

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
                    setBodyForQuestion(selectedData);
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
                    setBodyForQuestion(selectedData);
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
                    setBodyForQuestion(text);
                  },
                );
              case 'SCALE':
                return RatingSlider(
                  questionId: question['id'],
                  title: question['title'],
                  description: question['description'],
                  onRatingChanged: (rating) {
                    setBodyForQuestion(rating);
                  },
                );
              case 'YES_NO':
                return YesNoWidget(
                  questionId: question['id'],
                  title: question['title'],
                  description: question['description'],
                  onOptionChanged: (newValue) {
                    setBodyForQuestion(newValue);
                  },
                );
              case 'DATE':
                return DateTimePicker(
                  questionId: question['id'],
                  title: question['title'],
                  description: question['description'],
                  onDateTimeChanged: (date) {
                    setBodyForQuestion(date);
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

  Future<void> handleSubmit() async {
    final response =
        await _httpService.postArray('/cases/create-new-case', answers);
  }

  void setBodyForQuestion(Map<String, dynamic> answer) {
    int existingIndex = answers
        .indexWhere((element) => element['question'] == answer['question']);

    if (existingIndex != -1) {
      answers[existingIndex] = answer;
    } else {
      answers.add(answer);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomTopBar(
        isEditMode: true,
        editButtonText: 'Gem',
        onEdit: () {
          handleSubmit();
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
