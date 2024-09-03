import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CaseItem extends StatelessWidget {
  final int id;
  final String title;
  final String date;
  final String status;

  const CaseItem({
    Key? key,
    required this.id,
    required this.title,
    required this.date,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedDate;

    try {
      final DateTime parsedDate = DateTime.parse(date);
      formattedDate = DateFormat('dd MMM yyyy, HH:mm').format(parsedDate);
    } catch (e) {
      formattedDate = date;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                formattedDate,
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          Icon(
            status == 'APPROVED'
                ? Icons.check_circle
                : status == 'WAITING'
                    ? Icons.hourglass_empty
                    : Icons.cancel,
            color: status == 'APPROVED'
                ? Colors.green
                : status == 'WAITING'
                    ? Colors.yellow
                    : Colors.red,
            size: 32.0,
          ),
        ],
      ),
    );
  }
}
