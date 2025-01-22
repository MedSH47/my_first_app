import 'package:flutter/material.dart';
import '../model/Car.dart';
import '../service/CarService.dart';

class CarForm extends StatefulWidget {
  @override
  _CarFormState createState() => _CarFormState();
}

class _CarFormState extends State<CarForm> {
  final _formKey = GlobalKey<FormState>();
  final _marqueController = TextEditingController();
  final _modelController = TextEditingController();
  final _kilometredistanceController = TextEditingController();
  final _maxspeedController = TextEditingController();
  final _yearController = TextEditingController();
  final _horsepowerController = TextEditingController();
  final _problemsController = TextEditingController();
  final _essenceController = TextEditingController();
  final _gearController = TextEditingController();
  final _suspensionsystemController = TextEditingController();

  RPM? _selectedRPM;
  bool _isLoading = false;

  @override
  void dispose() {
    _marqueController.dispose();
    _modelController.dispose();
    _kilometredistanceController.dispose();
    _maxspeedController.dispose();
    _yearController.dispose();
    _horsepowerController.dispose();
    _problemsController.dispose();
    _essenceController.dispose();
    _gearController.dispose();
    _suspensionsystemController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && _selectedRPM != null) {
      setState(() {
        _isLoading = true;
      });

      Car newCar = Car(
        marque: _marqueController.text,
        model: _modelController.text,
        kilometredistance: int.parse(_kilometredistanceController.text),
        maxspeed: int.parse(_maxspeedController.text),
        year: _yearController.text,
        enginerpm: _selectedRPM!,
        horsepower: int.parse(_horsepowerController.text),
        problems: _problemsController.text.split(','),
        essence: int.parse(_essenceController.text),
        gear: int.parse(_gearController.text),
        suspensionsystem: double.parse(_suspensionsystemController.text),
      );

      try {
        await CarService.createCar(newCar);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Car created successfully!')),
        );
        Navigator.pushReplacementNamed(context, '/navbar');      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create car: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields and select an RPM value')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Car'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  _buildSectionTitle('Basic Information'),
                  _buildTextField(_marqueController, 'Marque'),
                  _buildTextField(_modelController, 'Model'),
                  _buildTextField(
                    _kilometredistanceController,
                    'Kilometers Traveled',
                    keyboardType: TextInputType.number,
                  ),
                  _buildTextField(
                    _maxspeedController,
                    'Max Speed',
                    keyboardType: TextInputType.number,
                  ),
                  _buildTextField(_yearController, 'Year (YYYY-MM-DD)'),
                  _buildDropdownField(),
                  _buildSectionTitle('Technical Details'),
                  _buildTextField(
                    _horsepowerController,
                    'Horsepower',
                    keyboardType: TextInputType.number,
                  ),
                  _buildTextField(_problemsController, 'Problems (comma-separated)'),
                  _buildTextField(
                    _essenceController,
                    'Essence',
                    keyboardType: TextInputType.number,
                  ),
                  _buildTextField(
                    _gearController,
                    'Gear',
                    keyboardType: TextInputType.number,
                  ),
                  _buildTextField(
                    _suspensionsystemController,
                    'Suspension System',
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      _isLoading ? 'Submitting...' : 'Submit',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? 'Please enter the $labelText' : null,
      ),
    );
  }

  Widget _buildDropdownField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<RPM>(
        value: _selectedRPM,
        decoration: InputDecoration(
          labelText: 'Engine RPM',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        items: RPM.values.map((rpm) {
          return DropdownMenuItem<RPM>(
            value: rpm,
            child: Text(rpm.toString().split('.').last),
          );
        }).toList(),
        onChanged: (RPM? value) {
          setState(() {
            _selectedRPM = value!;
          });
        },
        validator: (value) => value == null ? 'Please select an RPM value' : null,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
        ),
      ),
    );
  }
}
