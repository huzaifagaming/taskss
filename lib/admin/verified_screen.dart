import 'package:flutter/material.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerifiedScreen extends StatefulWidget {
  @override
  _VerifiedScreenState createState() => _VerifiedScreenState();
}

class _VerifiedScreenState extends State<VerifiedScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final codeController = TextEditingController();

  String generatedCode = '';
  String? selectedRole; // Make role selection mandatory
  bool emailSent = false;
  bool verified = false;
  bool isLoading = false;

  final roles = ['Student', 'Teacher', 'Manager'];

  String generateRandomCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(6, (index) => chars[Random().nextInt(chars.length)]).join();
  }

  Future<void> registerAndSendCode() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      // Create user
      final userCred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Send email verification
      await userCred.user!.sendEmailVerification();

      // Generate custom code
      generatedCode = generateRandomCode();

      // Save verification code to Firestore
      await FirebaseFirestore.instance.collection('verification_codes').doc(email).set({
        'code': generatedCode,
        'timestamp': FieldValue.serverTimestamp(),
      });

      setState(() {
        emailSent = true;
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verification email and code sent to $email')),
      );
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> verifyCodeAndAssignRole() async {
    final email = emailController.text.trim();
    final enteredCode = codeController.text.trim();

    if (enteredCode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter the verification code')),
      );
      return;
    }

    if (selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a role')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final doc = await FirebaseFirestore.instance.collection('verification_codes').doc(email).get();

      if (doc.exists && doc['code'] == enteredCode) {
        final user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
            'email': email,
            'role': selectedRole,
            'verified': true,
          });

          setState(() {
            verified = true;
            isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User verified and assigned role: $selectedRole')),
          );
        } else {
          throw Exception("User not found.");
        }
      } else {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid code')),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error verifying code: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin - Register User')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'User Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'User Password'),
              obscureText: true,
            ),
            SizedBox(height: 12),
            if (!emailSent)
              ElevatedButton(
                onPressed: isLoading ? null : registerAndSendCode,
                child: Text('Register & Send Verification'),
              ),
            if (emailSent && !verified) ...[
              TextField(
                controller: codeController,
                decoration: InputDecoration(labelText: 'Enter Verification Code'),
              ),
              DropdownButton<String>(
                value: selectedRole,
                hint: Text('Select Role'),
                onChanged: (value) => setState(() => selectedRole = value),
                items: roles.map((role) {
                  return DropdownMenuItem(value: role, child: Text(role));
                }).toList(),
              ),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: isLoading ? null : verifyCodeAndAssignRole,
                child: Text('Verify Code & Assign Role'),
              ),
            ],
            if (verified)
              Text('✅ User verified and added as $selectedRole', style: TextStyle(color: Colors.green)),
          ],
        ),
      ),
    );
  }
}
