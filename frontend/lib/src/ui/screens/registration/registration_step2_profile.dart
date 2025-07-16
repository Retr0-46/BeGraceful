// lib/src/ui/screens/registration/registration_step2_profile.dart
import 'package:flutter/material.dart';
import '../../../models/registration_data.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/src/providers/theme_provider.dart';
import '../../themes/app_theme.dart';
import 'package:provider/provider.dart';
import '../../../providers/user_provider.dart';
import '../../../services/auth_service.dart';
import '../../../services/profile_service.dart';

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
  final _lastNameController = TextEditingController();

  String? _gender;
  String? _activityLevel;
  String? _goal;

  double _height = 165;
  double _weight = 65;
  double _goalWeight = 0;

  bool _isLoading = false;
  String? _error;

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final userId = userProvider.userId;
      if (userId == null) {
        setState(() {
          _isLoading = false;
          _error = 'User ID not found';
        });
        return;
      }
      // Преобразуем значения для backend
      String? genderBackend;
      if (_gender == 'Male') genderBackend = 'male';
      else if (_gender == 'Female') genderBackend = 'female';
      else genderBackend = 'other';

      String? activityBackend;
      if (_activityLevel?.contains('Sedentary') == true) activityBackend = 'low';
      else if (_activityLevel?.contains('Lightly') == true) activityBackend = 'low';
      else if (_activityLevel?.contains('Moderately') == true) activityBackend = 'moderate';
      else if (_activityLevel?.contains('Very') == true) activityBackend = 'high';
      else if (_activityLevel?.contains('Extra') == true) activityBackend = 'high';
      else activityBackend = 'low';

      String? objectiveBackend;
      if (_goal == 'Lose weight') objectiveBackend = 'lose_weight';
      else if (_goal == 'Maintain weight') objectiveBackend = 'maintain_weight';
      else if (_goal == 'Gain weight') objectiveBackend = 'gain_weight';
      else objectiveBackend = '';

      // Ensure goalWeight respects backend validation (min 10)
      final int goalKg = _goalWeight < 10 ? 10 : _goalWeight.toInt();

      final profileData = {
        'user_id': userId,
        'first_name': _usernameController.text,
        'last_name': _lastNameController.text,
        'gender': genderBackend,
        'date_of_birth': _birthDateController.text,
        'height_cm': _height.toInt(),
        'weight_kg': _weight.toInt(),
        'activity_level': activityBackend,
        'goal_weight_kg': goalKg,
        'objective': objectiveBackend,
      };
      try {
        final completeResult = await AuthService.completeProfile(profileData);
        final jwt = completeResult['data']?['jwt'];
        if (jwt != null) {
          AuthService.saveJwt(jwt);
          final userIdFromJwt = AuthService.getUserIdFromJwt(jwt);
          if (userIdFromJwt != null) {
            userProvider.setUserId(userIdFromJwt);
            await tryLoadProfileWithRetry(userProvider);
          }
        }
        setState(() => _isLoading = false);
        widget.onFinish();
      } catch (e) {
        setState(() {
          _isLoading = false;
          _error = e is Exception ? e.toString() : 'Unknown error';
        });
      }
    }
  }

  void _adjustWeight(int delta) => setState(() => _weight = (_weight + delta).clamp(0, 500));
  void _adjustHeight(int delta) => setState(() => _height = (_height + delta).clamp(0, 300));

  Future<void> tryLoadProfileWithRetry(UserProvider userProvider, {int retries = 5, Duration delay = const Duration(seconds: 1)}) async {
    for (int i = 0; i < retries; i++) {
      await Future.delayed(delay);
      await userProvider.loadProfile();
      if (userProvider.profile != null) return;
    }
  }

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
                  controller: _lastNameController,
                  decoration: const InputDecoration(labelText: 'Last Name'),
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
                  validator: (val) {
                    final num? parsed = double.tryParse(val ?? '');
                    if (parsed == null) return 'Enter number';
                    if (parsed < 10) return 'Min 10kg';
                    return null;
                  },
                ),

                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C63FF),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: _isLoading
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('Complete', style: TextStyle(color: Colors.white)),
                  ),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 16),
                  Text(_error!, style: const TextStyle(color: Colors.red)),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
