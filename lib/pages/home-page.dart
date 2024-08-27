// home_page.dart

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:haenreg_mobile/config/api-config.dart';
import 'package:haenreg_mobile/pages/overview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Future<void> _login(
      BuildContext context, String username, String password) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/users/login');

    // Example login credentials
    final body = jsonEncode({
      'username': username,
      'password': password,
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Assuming the token is in the 'token' field of the response
        final token = responseData['token'];
        final username = responseData['username'];

        // Save the token to local storage
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('authToken', token);
        await prefs.setString('username', username);

        // Navigate to the next page or show success
        _navigateToOverview(context);
      } else {
        // Handle errors, e.g., show a dialog with the error message
        _showErrorDialog(context, 'Login failed');
      }
    } catch (error) {
      _showErrorDialog(context, 'An error occurred');
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  void _navigateToOverview(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Overview()),
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
                      onPressed: () => _login(context, 'peter', 'password123'),
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
                      onPressed: () => _login(context, 'lone', '321drowssap'),
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
