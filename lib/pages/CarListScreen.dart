import 'package:flutter/material.dart';
import 'package:my_first_app/pages/UpdateCarScreen.dart';
import '../model/Car.dart';
import '../service/CarService.dart';

class CarListScreen extends StatefulWidget {
  @override
  _CarListScreenState createState() => _CarListScreenState();
}

class _CarListScreenState extends State<CarListScreen> {
  late Future<List<Car>> _futureCars;

  @override
  void initState() {
    super.initState();
    _futureCars = _fetchCars();
  }

  Future<List<Car>> _fetchCars() async {
    try {
      return await CarService.getAllCars();
    } catch (e) {
      throw Exception("Failed to load cars: $e");
    }
  }

  void _navigateToUpdateScreen(Car car) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateCarScreen(car: car),
      ),
    ).then((_) {
      setState(() {
        _futureCars = _fetchCars();
      });
    });
  }

  void _deleteCar(String carId) async {
    try {
      await CarService.deleteCar(carId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Car deleted successfully!')),
      );
      setState(() {
        _futureCars = _fetchCars();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete car: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Cars'),
      ),
      body: FutureBuilder<List<Car>>(
        future: _futureCars,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No cars available.'),
            );
          }

          final cars = snapshot.data!;

          return ListView.builder(
            itemCount: cars.length,
            itemBuilder: (context, index) {
              final car = cars[index];
              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  title: Text('${car.marque} ${car.model}'),
                  subtitle: Text('Year: ${car.year}, Distance: ${car.kilometredistance} km'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _navigateToUpdateScreen(car),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteCar(car.id!),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
