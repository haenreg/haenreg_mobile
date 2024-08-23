// home_page.dart

import 'package:flutter/material.dart';
import 'package:haenreg_mobile/pages/registration-page.dart';
import 'package:haenreg_mobile/pages/update-page.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  void _navigateToRegistrationPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegistrationPage()),
    );
  }

  void _navigateToUpdatePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UpdatePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF83A8C9), // Start color
              Color(0xFF415363), // End color
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: Column(
                  children: [
                    Text(
                      'HænReg',
                      style: GoogleFonts.monoton(
                        textStyle: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      'Hændelsesregistrering',
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Buttons with images and text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 155, // Set the width of the button
                    height: 45, // Set the height of the button
                    child: ElevatedButton(
                      onPressed: () => _navigateToRegistrationPage(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10.0),
                        backgroundColor: Colors.white, // background color
                        foregroundColor: Colors.black, // text color
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/peter.png', // Make sure this image exists in your assets
                            width: 30,
                            height: 30,
                          ),
                          const SizedBox(
                              width:
                                  10), // Add some space between the image and the text
                          const Text('Peter'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  SizedBox(
                    width: 155, // Set the width of the button
                    height: 45, // Set the height of the button
                    child: ElevatedButton(
                      onPressed: () => _navigateToUpdatePage(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10.0),
                        backgroundColor: Colors.white, // background color
                        foregroundColor: Colors.black, // text color
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/lone.png', // Make sure this image exists in your assets
                            width: 30,
                            height: 30,
                          ),
                          const SizedBox(
                              width:
                                  10), // Add some space between the image and the text
                          const Text('Lone'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
