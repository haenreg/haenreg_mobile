import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:haenreg_mobile/components/date-selector.dart';
import 'package:haenreg_mobile/components/multi-select.dart';
import 'package:haenreg_mobile/components/scale-slider.dart';
import 'package:haenreg_mobile/components/text-input.dart';
import 'package:haenreg_mobile/components/yes-no-widget.dart';
import 'package:haenreg_mobile/services/http-service.dart';
import 'package:haenreg_mobile/components/custom-top-bar.dart';
import 'package:haenreg_mobile/components/select-one.dart';

class UpdatePage extends StatefulWidget {
  final String id;

  UpdatePage({required this.id});

  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  final HttpService _httpService = HttpService();
  final TextEditingController _textController = TextEditingController();

  List<Widget> questionWidgets = [];
  List<Map<String, dynamic>> updateAnswers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  Future<void> _fetchQuestions() async {
    try {
      final response = await _httpService.get('/questions/get-questions');
      final List<dynamic> questions = jsonDecode(response.body);

      final caseResponse =
          await _httpService.get('/cases/get-case/${widget.id}');
      final Map<String, dynamic> caseData = jsonDecode(caseResponse.body);

      final List<dynamic> answers = caseData['answers'];

      setState(() {
        questionWidgets = questions.map<Widget>((question) {
          // Find the corresponding answer for this question
          final answer = answers.firstWhere(
            (a) => a['question']['id'] == question['id'],
            orElse: () => null,
          );

          // Initialize variables for the initial selected value
          List<int>? initialSelectedChoicesIds;
          String? initialAnswerString;

          if (answer != null && answer['answerChoices'] != null) {
            initialSelectedChoicesIds =
                (answer['answerChoices'] as List<dynamic>)
                    .map<int>((choice) => choice['questionChoice']['id'] as int)
                    .toList();
          }
          if (answer != null && answer['answer'] != null) {
            initialAnswerString = answer['answer'];
          }

          switch (question['type']) {
            case 'SELECT_ONE':
              return SelectOne(
                questionId: question['id'],
                title: question['title'],
                description: question['description'],
                choices: List<Map<String, dynamic>>.from(
                  question['questionChoices'],
                ),
                initialSelectedChoiceId: initialSelectedChoicesIds?.first,
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
                initialSelectedChoicesIds: initialSelectedChoicesIds,
                onSelected: (selectedData) {
                  setBodyForQuestion(selectedData);
                },
              );
            case 'TEXT':
              return TextInputField(
                initialValue: initialAnswerString,
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
              int initialRating = int.tryParse(initialAnswerString ?? '') ?? 1;
              return RatingSlider(
                initialRating: initialRating,
                questionId: question['id'],
                title: question['title'],
                description: question['description'],
                onRatingChanged: (rating) {
                  setBodyForQuestion(rating);
                },
              );
            case 'YES_NO':
              return YesNoWidget(
                selectedOption: initialAnswerString ?? 'NO',
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
                  initialValue: initialAnswerString,
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
    } catch (error) {
      setState(() {
        questionWidgets = [];
        isLoading = false;
      });
      print('Failed to load questions: $error');
    }
  }

  Future<void> handleSubmit() async {
    final response = await _httpService.postArray(
        '/cases/update-case/${widget.id}', updateAnswers);
  }

  void setBodyForQuestion(Map<String, dynamic> answer) {
    int existingIndex = updateAnswers
        .indexWhere((element) => element['question'] == answer['question']);

    if (existingIndex != -1) {
      updateAnswers[existingIndex] = answer;
    } else {
      updateAnswers.add(answer);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomTopBar(
        isEditMode: true,
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
