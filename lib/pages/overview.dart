import 'package:flutter/material.dart';
import 'package:haenreg_mobile/components/custom-top-bar.dart';

class Overview extends StatelessWidget {
  const Overview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomTopBar(), // Use the custom top bar
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
        child: const Center(
          child: Text('Her kan man registrere!!'),
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
