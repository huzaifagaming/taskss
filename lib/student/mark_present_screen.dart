import 'package:flutter/material.dart';
import '../../services/database_service.dart';

class MarkPresentScreen extends StatelessWidget {
  final String studentId;
  final String studentName;

  MarkPresentScreen({required this.studentId, required this.studentName});

  void _markPresent(BuildContext context) async {
    await DatabaseService().markPresent(studentId, studentName);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Marked Present")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mark Present')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _markPresent(context),
          child: Text("I'm Present"),
        ),
      ),
    );
  }
}
