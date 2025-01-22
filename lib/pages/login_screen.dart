import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login() async {
    final response = await http.post(
      Uri.parse(
          'http://localhost:8080/Users/login'), // Adjust your login endpoint
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': _emailController.text,
        'password': _passwordController.text,
      }),
      
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      String? username = responseData['username'];

      // Handle successful login
      
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('username', responseData['username']);

      ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Welcome, $username!')),
          );
      Navigator.pushReplacementNamed(context, '/navbar');
    } else {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to login: ${response.body}')),
      );
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
