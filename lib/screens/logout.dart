import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LogoutPage extends StatelessWidget {
  const LogoutPage({super.key});

  // Function to log out the user
  Future<void> _logout(BuildContext context) async {
    try {
      // Sign out the user using Firebase Authentication
      await FirebaseAuth.instance.signOut();

      // Redirect to the home page after logout
      Navigator.pushReplacementNamed(context, '/');
      Navigator.of(context).pop();
    } catch (e) {
      // Handle logout errors
      print('Error during logout: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logout'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Are you sure you want to log out?'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _logout(context),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
