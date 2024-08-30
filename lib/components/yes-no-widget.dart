import 'package:flutter/material.dart';

class YesNoWidget extends StatefulWidget {
  final String selectedOption;
  final ValueChanged<String> onOptionChanged;

  YesNoWidget({required this.selectedOption, required this.onOptionChanged});

  @override
  _YesNoWidgetState createState() => _YesNoWidgetState();
}

class _YesNoWidgetState extends State<YesNoWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vælg et svar:',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Row(
          children: [
            Expanded(
              child: ListTile(
                title: const Text('Ja'),
                leading: Radio<String>(
                  value: 'Ja',
                  groupValue: widget.selectedOption,
                  onChanged: (String? value) {
                    if (value != null) {
                      widget.onOptionChanged(value);
                    }
                  },
                ),
              ),
            ),
            Expanded(
              child: ListTile(
                title: const Text('Nej'),
                leading: Radio<String>(
                  value: 'Nej',
                  groupValue: widget.selectedOption,
                  onChanged: (String? value) {
                    if (value != null) {
                      widget.onOptionChanged(value);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
