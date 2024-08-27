import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haenreg_mobile/components/case-item.dart';
import 'package:haenreg_mobile/components/custom-top-bar.dart';

class Overview extends StatelessWidget {
  const Overview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomTopBar(
          /* isEditMode: true, // Set this to true or false based on your requirement
        onEdit: () {
          print("Edit button clicked");
        }, */
          ),
// Use the custom top bar
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
              // List of CaseItems
              const CaseItem(
                title: 'Indskoling',
                date: '30-07-2024 - 13:45',
                isComplete: true,
              ),
              const CaseItem(
                title: 'Udskoling',
                date: '30-07-2024 - 13:45',
                isComplete: false,
              ),
              // Add more CaseItems as needed
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
