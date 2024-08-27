import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haenreg_mobile/components/case-item.dart';
import 'package:haenreg_mobile/components/custom-top-bar.dart';

class RegistrationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: CustomTopBar(
        isEditMode: true, // Aktiver redigeringstilstand
        onEdit: () {
          // Handling for rediger-knappen
          print("Rediger-knappen blev klikket");
        },
      ),
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
    ),
    );
  }
}