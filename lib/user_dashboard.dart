import 'package:flutter/material.dart';

class UserDashboard extends StatelessWidget {
  final String role;
  final String className;

  const UserDashboard({required this.role, required this.className});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$role - $className')),
      body: Center(
        child: Text('Welcome, $role!\nClass: $className', style: TextStyle(fontSize: 22)),
      ),
    );
  }
}
