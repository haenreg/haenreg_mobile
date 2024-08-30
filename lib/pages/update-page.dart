import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:haenreg_mobile/components/multi-select.dart';
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
  List<Widget> questionWidgets = [];
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
                initialSelectedChoicesIds: initialSelectedChoicesIds,
                onSelected: (selectedData) {
                  print("Selected Data: $selectedData");
                },
              );
            // case 'SCALE':
            //   return Scale(
            //     title: question['title'],
            //     description: question['description'],
            //     initialValue: initialAnswerString != null ? int.tryParse(initialAnswerString) : null,
            //     onSelected: (selectedData) {
            //       print("Selected Data: $selectedData");
            //       // Handle the submitted data here
            //     },
            //   );
            // Add more cases here for different question types as you create more components
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomTopBar(
        isEditMode: true,
        onEdit: () {
          print('Edit button clicked ${widget.id}');
        },
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : ListView.builder(
                itemCount: questionWidgets.length,
                itemBuilder: (context, index) {
                  return questionWidgets[index];
                },
              ),
      ),
    );
  }
}
