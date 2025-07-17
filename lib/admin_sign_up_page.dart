import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminSignupPage extends StatefulWidget {
  @override
  _AdminSignupPageState createState() => _AdminSignupPageState();
}

class _AdminSignupPageState extends State<AdminSignupPage> {
  final TextEditingController userEmailController = TextEditingController();
  final TextEditingController userPasswordController = TextEditingController();
  final List<String> roles = ['Student', 'Teacher', 'Manager'];
  String selectedRole = 'Student';

  // This will run once to verify admin login
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAdminPassword();
    });
  }

  void _checkAdminPassword() async {
    final adminPasswordController = TextEditingController();

    final result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Admin Password Required'),
        content: TextField(
          controller: adminPasswordController,
          obscureText: true,
          decoration: InputDecoration(labelText: 'Enter Admin Password'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (adminPasswordController.text == 'admin123') {
                Navigator.pop(context, true);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Invalid Admin Password')),
                );
              }
            },
            child: Text('Confirm'),
          ),
        ],
      ),
    );

    if (result != true) {
      Navigator.pop(context); // leave this screen
    }
  }

  Future<void> _createUser() async {
    final email = userEmailController.text.trim();
    final password = userPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email & Password required')),
      );
      return;
    }

    try {
      // create user in Firebase Auth
      UserCredential userCred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // store user info in Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCred.user!.uid).set({
        'email': email,
        'role': selectedRole,
        'createdAt': DateTime.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User created: $email as $selectedRole')),
      );

      userEmailController.clear();
      userPasswordController.clear();
      setState(() {
        selectedRole = 'Student';
      });
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.message}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin - Create User')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: userEmailController,
              decoration: InputDecoration(labelText: 'User Email'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: userPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'User Password'),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedRole,
              items: roles.map((role) => DropdownMenuItem(value: role, child: Text(role))).toList(),
              onChanged: (value) => setState(() => selectedRole = value!),
              decoration: InputDecoration(labelText: 'Select Role'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createUser,
              child: Text('Create User'),
            ),
          ],
        ),
      ),
    );
  }
}
