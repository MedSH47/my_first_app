import 'package:flutter/material.dart';
import 'login_screen.dart'; // Your login screen
import 'signup_screen.dart'; // Your signup screen
import 'package:shared_preferences/shared_preferences.dart'; // For saving user login state

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _username;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Load user data from shared preferences (assuming you saved user name there after login)
  _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username');
    });
  }

  // Logout function: Remove user data and navigate to login screen
  _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');  // Clear saved username
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),  // Navigate to LoginScreen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Car Management'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: _username != null
                  ? Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          child: Icon(Icons.person, size: 30),
                        ),
                        SizedBox(width: 10),
                        Text(
                          _username!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      'Car App',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
            ),
            _username != null
                ? ListTile(
                    title: Text('Logout'),
                    onTap: _logout,  // Call logout function when tapped
                  )
                : ListTile(
                    title: Text('Login'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                  ),
            ListTile(
              title: Text('Sign Up'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignupScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
  child: _username != null
      ? Text('Welcome, $_username!')
      : Text('Please log in to continue.'),
),

    );
    
  }
}
