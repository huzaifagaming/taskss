import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminSignupScreen extends StatefulWidget {
  @override
  _AdminSignupScreenState createState() => _AdminSignupScreenState();
}

class _AdminSignupScreenState extends State<AdminSignupScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String selectedRole = 'student';

  final Map<String, List<String>> roleWorkOptions = {
    'student': [
      'Attend class regularly',
      'Complete assigned courses',
      'Submit assignments',
    ],
    'teacher': [
      'Take attendance',
      'Provide attendance result',
      'Teach assigned courses',
    ],
    'manager': [
      'Monitor attendance reports',
      'Manage schedules',
      'Communicate with teachers',
    ],
  };

  List<String> selectedWorks = [];

  final List<String> roles = ['student', 'teacher', 'manager'];

  void createUser() async {
    try {
      final auth = FirebaseAuth.instance;
      final firestore = FirebaseFirestore.instance;

      final newUser = await auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await firestore.collection('users').doc(newUser.user!.uid).set({
        'email': emailController.text.trim(),
        'role': selectedRole,
        'works': selectedWorks,
        'isWorkCompleted': false,
        'createdAt': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ $selectedRole account created')),
      );

      // Reset fields
      emailController.clear();
      passwordController.clear();
      setState(() {
        selectedRole = 'student';
        selectedWorks = [];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentWorkOptions = roleWorkOptions[selectedRole] ?? [];

    return Scaffold(
      appBar: AppBar(title: Text('Admin - Create User')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'User Email'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'User Password'),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedRole,
              decoration: InputDecoration(labelText: 'Select Role'),
              items: roles.map((role) {
                return DropdownMenuItem(value: role, child: Text(role));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedRole = value!;
                  selectedWorks = [];
                });
              },
            ),
            SizedBox(height: 20),
            Text(
              'Select Work for $selectedRole:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...currentWorkOptions.map((work) {
              return CheckboxListTile(
                title: Text(work),
                value: selectedWorks.contains(work),
                onChanged: (bool? selected) {
                  setState(() {
                    if (selected == true) {
                      selectedWorks.add(work);
                    } else {
                      selectedWorks.remove(work);
                    }
                  });
                },
              );
            }).toList(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: selectedWorks.isEmpty
                  ? null
                  : createUser,
              child: Text('Create $selectedRole Account'),
            ),
          ],
        ),
      ),
    );
  }
}

