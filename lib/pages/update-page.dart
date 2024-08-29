import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:haenreg_mobile/services/http-service.dart';
import 'package:haenreg_mobile/components/custom-top-bar.dart';
import 'package:haenreg_mobile/components/select-one.dart';
// import 'package:haenreg_mobile/components/scale.dart'; // Uncomment when you have a Scale component

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
            // case 'SCALE':
            //   return Scale(
            //     title: question['title'],
            //     description: question['description'],
            //     // Pass any other necessary parameters
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
