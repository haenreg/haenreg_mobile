import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haenreg_mobile/config/api-config.dart';
import 'package:haenreg_mobile/pages/update-page.dart';
import 'package:haenreg_mobile/services/http-service.dart';
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
  final HttpService _httpService = HttpService();

  List<CaseItem> caseItems = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData(); // Fetch data when the widget is initialized
  }

  Future<void> _fetchData() async {
    try {
      final response = await _httpService.get('/cases/get-cases-by-user');

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);

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
                if (answer['answer'] != null && answer['answer'].isNotEmpty) {
                  title = answer['answer'];
                } else if (answer['answerChoices'] != null &&
                    answer['answerChoices'].isNotEmpty) {
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
              id: data['id'],
              title: title ?? 'Unknown',
              date: date ?? 'Unknown',
              status: data['approved'],
            );
          }).toList();
        });
      } else {
        isLoading = false;
        print('Failed to fetch data: ${response.statusCode}');
      }
    } catch (error) {
      isLoading = false;
      print('An error occurred: $error');
    } finally {
      isLoading = false;
      print(caseItems.length);
    }
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
                child: isLoading
                    ? Center(
                        child:
                            CircularProgressIndicator(), // Show a loading indicator while data is being fetched
                      )
                    : ListView(
                        padding: EdgeInsets.zero,
                        children: caseItems.isNotEmpty
                            ? caseItems.map((caseItem) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UpdatePage(
                                          id: caseItem.id
                                              .toString(), // Ensure id is passed as a string
                                        ),
                                      ),
                                    );
                                  },
                                  child:
                                      caseItem, // Use the CaseItem widget directly
                                );
                              }).toList()
                            : [
                                const Center(child: Text('No cases available')),
                              ],
                      ),
              )
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
