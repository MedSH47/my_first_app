import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/Car.dart';

class CarService {
  static const String apiUrl = 'http://localhost:8080/Cars';

  static Future<void> createCar(Car car) async {
    final response = await http.post(
      Uri.parse("$apiUrl/Create"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(car.toJson()),
    );
    print(response);

    // Check for successful response
    if (response.statusCode == 200) {
      // Successfully created car
      print('Car created successfully: ${response.body}');
    } else {
      // Handle failure
      throw Exception('Failed to create car: ${response.body}');
    }
  }
  static Future<List<Car>> getAllCars() async {
  final response = await http.get(
    Uri.parse('$apiUrl/All'), // Ensure this matches your backend endpoint
  );

  if (response.statusCode == 200) {
    List<dynamic> carsJson = json.decode(response.body);
    return carsJson.map((car) => Car.fromJson(car)).toList();
  } else {
    throw Exception('Failed to load cars: ${response.body}');
  }
}

}
