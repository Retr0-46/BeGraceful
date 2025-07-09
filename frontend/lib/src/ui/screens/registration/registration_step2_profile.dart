// lib/src/ui/screens/registration/registration_step2_profile.dart
import 'package:flutter/material.dart';
import '../../../models/registration_data.dart';

class RegistrationStep2 extends StatefulWidget {
  final RegistrationData data;
  final VoidCallback onFinish;

  const RegistrationStep2({super.key, required this.data, required this.onFinish});

  @override
  State<RegistrationStep2> createState() => _RegistrationStep2State();
}

class _RegistrationStep2State extends State<RegistrationStep2> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _birthDateController = TextEditingController();

  String? _gender;
  String? _activityLevel;
  String? _goal;

  double? _height;
  double? _weight;
  double? _goalWeight;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.data.username = _usernameController.text;
      widget.data.gender = _gender;
      widget.data.birthDate = DateTime.tryParse(_birthDateController.text);
      widget.data.height = _height;
      widget.data.weight = _weight;
      widget.data.activityLevel = _activityLevel;
      widget.data.goal = _goal;
      widget.data.goalWeight = _goalWeight;
      widget.onFinish();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const Text('Personal Information', style: TextStyle(fontSize: 22)),
            const SizedBox(height: 20),
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
              validator: (val) => val!.isEmpty ? 'Required' : null,
            ),
            DropdownButtonFormField<String>(
              value: _gender,
              items: ['Male', 'Female'].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
              onChanged: (val) => setState(() => _gender = val),
              decoration: const InputDecoration(labelText: 'Gender'),
              validator: (val) => val == null ? 'Required' : null,
            ),
            TextFormField(
              controller: _birthDateController,
              decoration: const InputDecoration(labelText: 'Birth Date (YYYY-MM-DD)'),
              validator: (val) => DateTime.tryParse(val ?? '') == null ? 'Invalid date' : null,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Height (cm)'),
              keyboardType: TextInputType.number,
              onChanged: (val) => _height = double.tryParse(val),
              validator: (val) => double.tryParse(val!) != null ? null : 'Enter number',
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Weight (kg)'),
              keyboardType: TextInputType.number,
              onChanged: (val) => _weight = double.tryParse(val),
              validator: (val) => double.tryParse(val!) != null ? null : 'Enter number',
            ),
            DropdownButtonFormField<String>(
              value: _activityLevel,
              items: [
                'Sedentary',
                'Lightly Active',
                'Moderately Active',
                'Very Active',
              ].map((a) => DropdownMenuItem(value: a, child: Text(a))).toList(),
              onChanged: (val) => setState(() => _activityLevel = val),
              decoration: const InputDecoration(labelText: 'Activity Level'),
              validator: (val) => val == null ? 'Required' : null,
            ),
            DropdownButtonFormField<String>(
              value: _goal,
              items: ['Lose weight', 'Maintain weight', 'Gain weight']
                  .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                  .toList(),
              onChanged: (val) => setState(() => _goal = val),
              decoration: const InputDecoration(labelText: 'Goal'),
              validator: (val) => val == null ? 'Required' : null,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Goal Weight (kg)'),
              keyboardType: TextInputType.number,
              onChanged: (val) => _goalWeight = double.tryParse(val),
              validator: (val) => double.tryParse(val!) != null ? null : 'Enter number',
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _submit, child: const Text('Complete')),
          ],
        ),
      ),
    );
  }
}
