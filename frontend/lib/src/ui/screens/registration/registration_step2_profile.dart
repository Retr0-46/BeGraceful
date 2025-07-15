// lib/src/ui/screens/registration/registration_step2_profile.dart
import 'package:flutter/material.dart';
import '../../../models/registration_data.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/src/providers/theme_provider.dart';
import '../../themes/app_theme.dart';
import 'package:provider/provider.dart';

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

  double _height = 0;
  double _weight = 0;
  double _goalWeight = 0;

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

  void _adjustWeight(int delta) => setState(() => _weight = (_weight + delta).clamp(0, 500));
  void _adjustHeight(int delta) => setState(() => _height = (_height + delta).clamp(0, 300));

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).colorScheme.onBackground,
        elevation: 0,
        centerTitle: true,

        title: RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                text: 'Welcome to ',
                style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
              ),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: SvgPicture.asset(
                  'assets/images/BeGraceful.svg',
                  height: 20,
                ),
              ),
            ],
          ),
        ),

        actions: [
          IconButton(
            icon: Image.asset(
              themeProvider.isDarkMode
                  ? 'assets/images/main_page/sun-light-theme.png'
                  : 'assets/images/main_page/moon-dark-theme.png',
              width: 24,
              height: 24,
            ),
            onPressed: () {
              themeProvider.toggleTheme(!themeProvider.isDarkMode);
            },
          ),
        ],
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const LinearProgressIndicator(
                  value: 1.00,
                  backgroundColor: Colors.grey,
                  valueColor: AlwaysStoppedAnimation(Color(0xFF7B61FF)),
                ),
                const SizedBox(height: 24),
                const Text('Personal Information *', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _birthDateController,
                  decoration: const InputDecoration(labelText: 'Birth Date (YYYY-MM-DD)'),
                  validator: (val) => DateTime.tryParse(val ?? '') == null ? 'Invalid date' : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _gender,
                  items: ['Male', 'Female'].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                  onChanged: (val) => setState(() => _gender = val),
                  decoration: const InputDecoration(labelText: 'Sex'),
                  validator: (val) => val == null ? 'Required' : null,
                ),

                const SizedBox(height: 24),
                const Text('Physical Data *', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),

                // Weight
                Row(
                  children: [
                    const Text('Current Weight'),
                    const SizedBox(width: 12),
                    IconButton(onPressed: () => _adjustWeight(-1), icon: const Icon(Icons.remove)),
                    Text('${_weight.toInt()}'),
                    IconButton(onPressed: () => _adjustWeight(1), icon: const Icon(Icons.add)),
                    const Text('Kg'),
                  ],
                ),
                const SizedBox(height: 8),

                // Height
                Row(
                  children: [
                    const Text('Height'),
                    const SizedBox(width: 48),
                    IconButton(onPressed: () => _adjustHeight(-1), icon: const Icon(Icons.remove)),
                    Text('${_height.toInt()}'),
                    IconButton(onPressed: () => _adjustHeight(1), icon: const Icon(Icons.add)),
                    const Text('cm'),
                  ],
                ),

                const SizedBox(height: 16),

                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 48),
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: _activityLevel,
                    items: [
                      'Sedentary – Little or no exercise (e.g. desk job)',
                      'Lightly Active – Light exercise/sports 1–3 days/week',
                      'Moderately Active – Moderate exercise 3–5 days/week',
                      'Very Active – Hard exercise 6–7 days/week',
                      'Extra Active – Very intense training or physical job',
                    ].map((a) => DropdownMenuItem(value: a, child: Text(a))).toList(),
                    onChanged: (val) => setState(() => _activityLevel = val),
                    decoration: const InputDecoration(labelText: 'Activity Level'),
                    validator: (val) => val == null ? 'Required' : null,
                  ),
                ),
                

                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  value: _goal,
                  items: ['Lose weight', 'Maintain weight', 'Gain weight']
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
                  onChanged: (val) => setState(() => _goal = val),
                  decoration: const InputDecoration(labelText: 'Goal'),
                  validator: (val) => val == null ? 'Required' : null,
                ),

                const SizedBox(height: 12),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Goal Weight (kg)'),
                  keyboardType: TextInputType.number,
                  onChanged: (val) => _goalWeight = double.tryParse(val) ?? 0,
                  validator: (val) => double.tryParse(val ?? '') != null ? null : 'Enter number',
                ),

                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C63FF),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Complete', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
