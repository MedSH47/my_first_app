import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/User.dart';

class UserService {
  static const String _baseUrl = 'http://localhost:8080/Users';

  // Fetch all users
  static Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse('$_baseUrl/All'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  // Fetch a single user by ID
  static Future<User> fetchUserById(String id) async {
    final response = await http.get(Uri.parse('$_baseUrl/$id'));

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }

  // Create a new user
  static Future<int> createUser(User user) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()),
    );

    return response.statusCode;

  }

  // Update an existing user
  static Future<User> updateUser(String id, User user) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/Modify/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()),
    );

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update user');
    }
  }

  // Delete a user
  static Future<void> deleteUser(String id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/Delete/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete user');
    }
  }

  // Login a user
  static Future<String> loginUser(User user) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()),
    );

    if (response.statusCode == 200) {
      return 'Login successful';
    } else {
      return 'Invalid credentials';
    }
  }
}
