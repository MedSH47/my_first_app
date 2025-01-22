import 'package:flutter/material.dart';
import 'package:my_first_app/pages/MainNavbar.dart';
import 'package:my_first_app/pages/login_screen.dart';
import 'pages/HomeScreen.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car Management App',
      initialRoute: '/home',
      routes: {
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/navbar':(context) =>MainNavbar(),
       
      },
    );
  }
}

