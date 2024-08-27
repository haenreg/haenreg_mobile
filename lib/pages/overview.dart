import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haenreg_mobile/config/api-config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:haenreg_mobile/components/case-item.dart';
import 'package:haenreg_mobile/components/custom-top-bar.dart';

class Overview extends StatefulWidget {
  const Overview({super.key});

  @override
  _OverviewState createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  List<CaseItem> caseItems = [];

  Future<String?> getTokenFromStorage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  Future<void> _fetchData() async {
    final token = await getTokenFromStorage();

    if (token == null) {
      print('No token found');
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/cases/get-cases-by-user'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);

        // Generate a list of CaseItems
        setState(() {
          caseItems = responseData.map<CaseItem>((data) {
            String? date;
            String? title;

            bool dateFound = false;

            for (var answer in data['answers']) {
              if (answer['question']['type'] == 'DATE') {
                date = answer['answer'];
                dateFound = true;
              } else if (dateFound && title == null) {
                // Check if the answer is not empty
                if (answer['answer'] != null && answer['answer'].isNotEmpty) {
                  title = answer['answer'];
                } else if (answer['answerChoices'] != null &&
                    answer['answerChoices'].isNotEmpty) {
                  // Check the answerChoices
                  var firstChoice =
                      answer['answerChoices'].first['questionChoice'];
                  if (firstChoice['dependent'] != null) {
                    title = firstChoice['dependent']['choice'];
                  } else {
                    title = firstChoice['choice'];
                  }
                }
              }
            }

            return CaseItem(
              title: title ?? 'Unknown',
              date: date ?? 'Unknown',
              status: data['approved'],
            );
          }).toList();
        });
      } else {
        print('Failed to fetch data: ${response.statusCode}');
      }
    } catch (error) {
      print('An error occurred: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData(); // Fetch data when the widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomTopBar(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFEDF4FA), // #EDF4FA
              Color(0xFFEBEAE7), // #EBEAE7
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 120.0, 16.0, 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hændelsesregistrering',
                style: GoogleFonts.montserrat(
                  textStyle: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Dine hændelser',
                style: GoogleFonts.montserrat(
                  textStyle: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              // Dynamically generate CaseItems
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: caseItems.isNotEmpty
                      ? caseItems
                      : [
                          const Center(child: Text('No cases available')),
                        ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: Overview(),
  ));
}
