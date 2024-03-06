import 'package:alakh_car/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  String imgFolder = "http://alakh.avinds.com/uploads/";

  late bool isLoggedIn = false;
  //bool isLoggedIn = false;

  Future<void> _login() async {
    final response = await http
        .post(Uri.parse('http://avinds.com/api/login/index.php'), body: {
      'email': _usernameController.text,
      'password': _passwordController.text,
    });

    final result = json.decode(response.body);

    String message = result['message'].toString();
    String statusCode = result['statusCode'].toString();
    String token = result['token'].toString();
    String email = result['data']['email'].toString();
    String firstName = result['data']['first_name'].toString();
    String lastName = result['data']['last_name'].toString();

    if (statusCode == "201") {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('email', email);
      await prefs.setString('first_name', firstName);
      await prefs.setString('last_name', lastName);
      await prefs.setBool('isLoggedIn', true);

      isLoggedIn = true;

      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("login success"),
              content: Text(message),
              actions: <Widget>[
                MaterialButton(
                  height: 45.0,
                  color: Colors.blueAccent,
                  textColor: Colors.white,
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Home()));
                  },
                ),
              ],
            );
          });
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Login failed"),
            content: Text(message),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: MaterialButton(
                  height: 45.0,
                  color: Colors.blueAccent,
                  textColor: Colors.white,
                  onPressed: _login,
                  child: const Text('Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
