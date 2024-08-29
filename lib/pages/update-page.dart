import 'package:flutter/material.dart';
import 'package:haenreg_mobile/components/custom-top-bar.dart';

class UpdatePage extends StatelessWidget {
  final String id;

  UpdatePage({required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomTopBar(
        isEditMode: true,
        onEdit: () {
          print("Edit button clicked");
        },
      ),
      body: Center(
        child: Text('Case ID: $id'),
      ),
    );
  }
}