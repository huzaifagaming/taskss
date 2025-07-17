import 'package:flutter/material.dart';
import 'main.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  void handleLogin(BuildContext context, String className) {
    if (email.text == 'admin@class.com' && password.text == 'admin123') {
      // MyApp.loginCount++;
      Navigator.pushNamed(context, '/classDetail', arguments: className);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid Admin Login')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final String className = ModalRoute.of(context)?.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(title: Text('Admin Login - $className')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: email, decoration: InputDecoration(labelText: 'Email')),
            TextField(controller: password, obscureText: true, decoration: InputDecoration(labelText: 'Password')),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => handleLogin(context, className),
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
