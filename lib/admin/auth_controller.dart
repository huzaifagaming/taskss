import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> registerUser(String email, String password, String trim) async {
    try {
      isLoading.value = true;

      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // If new user: send verification
      if (!result.user!.emailVerified) {
        await result.user!.sendEmailVerification();

        Get.defaultDialog(
          title: "Verify Email",
          content: Column(
            children: [
              Icon(Icons.email, size: 40, color: Colors.blue),
              SizedBox(height: 10),
              Text("We have sent a verification link to:\n$email"),
            ],
          ),
          confirm: ElevatedButton(
            onPressed: () {
              Get.back();
            },
            child: Text("OK"),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Register Error", e.message ?? "Unknown error");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginUser(String email, String password) async {
    try {
      isLoading.value = true;
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!result.user!.emailVerified) {
        // Show popup for not verified
        Get.defaultDialog(
          title: "Email Not Verified",
          middleText:
          "Please verify your email first.\nCheck your inbox or spam folder.",
          confirm: ElevatedButton(
            onPressed: () async {
              await result.user!.sendEmailVerification();
              Get.back();
              Get.snackbar("Verification Sent", "Email sent again!");
            },
            child: Text("Resend Email"),
          ),
          cancel: TextButton(
            onPressed: () => Get.back(),
            child: Text("Cancel"),
          ),
        );
      } else {
        Get.snackbar("Success", "Login successful!");
      }
    } catch (e) {
      Get.snackbar("Login Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkVerification() async {
    await _auth.currentUser?.reload();
    if (_auth.currentUser!.emailVerified) {
      Get.snackbar("Verified", "Email has been verified!");
    } else {
      Get.snackbar("Not Verified", "Still not verified.");
    }
  }
}
