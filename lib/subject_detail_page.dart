import 'package:flutter/material.dart';

class SubjectDetailPage extends StatelessWidget {
  final String subject;
  final String courseContent;

  SubjectDetailPage({required this.subject, required this.courseContent});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$subject Course'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          courseContent,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
