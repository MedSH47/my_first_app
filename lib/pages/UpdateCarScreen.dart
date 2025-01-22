import 'package:flutter/material.dart';
import '../model/Car.dart';
import '../service/CarService.dart';

class UpdateCarScreen extends StatefulWidget {
  final Car car; // The car to be updated

  UpdateCarScreen({required this.car});

  @override
  _UpdateCarScreenState createState() => _UpdateCarScreenState();
}

class _UpdateCarScreenState extends State<UpdateCarScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _marqueController;
  late TextEditingController _modelController;
  late TextEditingController _kilometreDistanceController;
  late TextEditingController _maxSpeedController;
  late TextEditingController _yearController;
  late TextEditingController _horsepowerController;
  late TextEditingController _problemsController;
  late TextEditingController _essenceController;
  late TextEditingController _gearController;
  late TextEditingController _suspensionSystemController;

  RPM? _selectedRPM;

  @override
  void initState() {
    super.initState();

    _marqueController = TextEditingController(text: widget.car.marque);
    _modelController = TextEditingController(text: widget.car.model);
    _kilometreDistanceController =
        TextEditingController(text: widget.car.kilometredistance.toString());
    _maxSpeedController =
        TextEditingController(text: widget.car.maxspeed.toString());
    _yearController = TextEditingController(text: widget.car.year);
    _horsepowerController =
        TextEditingController(text: widget.car.horsepower.toString());
    _problemsController =
        TextEditingController(text: widget.car.problems.join(", "));
    _essenceController =
        TextEditingController(text: widget.car.essence.toString());
    _gearController =
        TextEditingController(text: widget.car.gear.toString());
    _suspensionSystemController =
        TextEditingController(text: widget.car.suspensionsystem.toString());

    _selectedRPM = widget.car.enginerpm;
  }

  Future<void> _updateCar() async {
    if (_formKey.currentState!.validate()) {
      final updatedCar = Car(
        id: widget.car.id,
        marque: _marqueController.text,
        model: _modelController.text,
        kilometredistance:
            int.parse(_kilometreDistanceController.text),
        maxspeed: int.parse(_maxSpeedController.text),
        year: _yearController.text,
        enginerpm: _selectedRPM!,
        horsepower: int.parse(_horsepowerController.text),
        problems: _problemsController.text.split(", ").map((e) => e.trim()).toList(),
        essence: int.parse(_essenceController.text),
        gear: int.parse(_gearController.text),
        suspensionsystem:
            double.parse(_suspensionSystemController.text),
      );

      try {
        await CarService.updateCar(updatedCar.id,updatedCar);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Car updated successfully!')),
        );
        Navigator.pop(context); 
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update car: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Car'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _marqueController,
                decoration: InputDecoration(labelText: 'Marque'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter marque' : null,
              ),
              TextFormField(
                controller: _modelController,
                decoration: InputDecoration(labelText: 'Model'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter model' : null,
              ),
              TextFormField(
                controller: _kilometreDistanceController,
                decoration: InputDecoration(labelText: 'Kilometre Distance'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty
                    ? 'Enter kilometre distance'
                    : null,
              ),
              TextFormField(
                controller: _maxSpeedController,
                decoration: InputDecoration(labelText: 'Max Speed'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter max speed' : null,
              ),
              TextFormField(
                controller: _yearController,
                decoration: InputDecoration(labelText: 'Year'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter year' : null,
              ),
              DropdownButtonFormField<RPM>(
                value: _selectedRPM,
                onChanged: (value) => setState(() => _selectedRPM = value),
                decoration: InputDecoration(labelText: 'Engine RPM'),
                items: RPM.values.map((rpm) {
                  return DropdownMenuItem(
                    value: rpm,
                    child: Text(rpm.toString().split('.').last),
                  );
                }).toList(),
                validator: (value) =>
                    value == null ? 'Select engine RPM' : null,
              ),
              TextFormField(
                controller: _horsepowerController,
                decoration: InputDecoration(labelText: 'Horsepower'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter horsepower' : null,
              ),
              TextFormField(
                controller: _problemsController,
                decoration: InputDecoration(
                  labelText: 'Problems',
                  hintText: 'Separate problems with commas',
                ),
              ),
              TextFormField(
                controller: _essenceController,
                decoration: InputDecoration(labelText: 'Essence'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter essence' : null,
              ),
              TextFormField(
                controller: _gearController,
                decoration: InputDecoration(labelText: 'Gear'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter gear' : null,
              ),
              TextFormField(
                controller: _suspensionSystemController,
                decoration: InputDecoration(labelText: 'Suspension System'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty
                    ? 'Enter suspension system value'
                    : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateCar,
                child: Text('Update Car'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
