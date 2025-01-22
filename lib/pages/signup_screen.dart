import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../model/User.dart';
import '../service/UserService.dart'; // Assuming you have UserService to create a user

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _idcarController = TextEditingController();
  final _countryController = TextEditingController();
  bool _isAutoLocation = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _idcarController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  // Get current country using geolocation
  Future<void> _getCountryFromLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      // Check if location services are enabled
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Location services are disabled.');
        return;
      }

      // Check for location permission
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.deniedForever) {
        print('Location permission is permanently denied.');
        return;
      }

      if (permission == LocationPermission.denied) {
        // Request permission
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        // Permission granted, proceed with location fetching
        Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        print("Position obtained: Latitude: ${position.latitude}, Longitude: ${position.longitude}");

        // Get placemarks (addresses) from the coordinates
        List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
        print("Placemarks obtained: $placemarks");

        if (placemarks.isNotEmpty) {
          // Extract the country from the placemark (first item in the list)
          String country = placemarks.first.country ?? 'Unknown';
          print("Country found: $country");

          setState(() {
            _countryController.text = country;
          });
        } else {
          print("No placemarks found for the given coordinates.");
        }
      } else {
        print('Location permission denied');
      }
    } catch (e) {
      print("Error while fetching location: $e");
    }
  }

  // Method to submit the form
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      User newUser = User(
        username: _usernameController.text,
        password: _passwordController.text,
        email: _emailController.text,
        country: _countryController.text,
      );

      try {
        await UserService.createUser(newUser);  // Assuming you have UserService to create user
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User created successfully!')));
        Navigator.pop(context);  // Navigate back after successful signup
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to create user: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter your username' : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) => value == null || value.isEmpty ? 'Please enter your password' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value == null || value.isEmpty ? 'Please enter your email' : null,
              ),
              TextFormField(
                controller: _idcarController,
                decoration: InputDecoration(labelText: 'Car ID'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter your car ID' : null,
              ),
              // Radio Buttons to choose between manual or automatic country detection
              Row(
                children: [
                  Radio<bool>(
                    value: false,
                    groupValue: _isAutoLocation,
                    onChanged: (bool? value) {
                      setState(() {
                        _isAutoLocation = value!;
                        if (!_isAutoLocation) {
                          _countryController.clear();  // Clear country if choosing manual input
                        }
                      });
                    },
                  ),
                  Text('Enter Country Manually'),
                  Radio<bool>(
                    value: true,
                    groupValue: _isAutoLocation,
                    onChanged: (bool? value) {
                      setState(() {
                        _isAutoLocation = value!;
                        if (_isAutoLocation) {
                          _getCountryFromLocation();  // Fetch country using geolocation
                        }
                      });
                    },
                  ),
                  Text('Use Auto Location'),
                ],
              ),
              TextFormField(
                controller: _countryController,
                decoration: InputDecoration(labelText: 'Country'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter your country' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
