import 'package:flutter/material.dart';
import 'HomeScreen.dart'; // Ensure this import is correct
import 'CarForm.dart';
import 'CarListScreen.dart';

class MainNavbar extends StatefulWidget {
  @override
  _MainNavbarState createState() => _MainNavbarState();
}

class _MainNavbarState extends State<MainNavbar> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(), // HomeScreen is now a simple widget
    CarForm(),
    CarListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Car',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'View Cars',
          ),
        ],
      ),
    );
  }
}