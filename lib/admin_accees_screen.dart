import 'package:flutter/material.dart';
import 'admin_sign_up.dart';

class AdminAccessScreen extends StatefulWidget {
  @override
  _AdminAccessScreenState createState() => _AdminAccessScreenState();
}

class _AdminAccessScreenState extends State<AdminAccessScreen> {
  final passwordController = TextEditingController();
  final String adminPassword = 'admin1234'; // ✅ Set your admin password

  void checkPassword() {
    if (passwordController.text.trim() == adminPassword) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => AdminSignupScreen(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Incorrect admin password')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Access')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Enter Admin Password to Continue',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Admin Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: checkPassword,
              child: Text('Proceed'),
            ),
          ],
        ),
      ),
    );
  }
}