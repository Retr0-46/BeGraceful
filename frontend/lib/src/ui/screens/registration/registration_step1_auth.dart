import 'package:flutter/material.dart';
import '../../../models/registration_data.dart';
import '../../../services/auth_service.dart';

class RegistrationStep1 extends StatefulWidget {
  final VoidCallback onNext;
  final RegistrationData data;

  const RegistrationStep1({super.key, required this.onNext, required this.data});

  @override
  State<RegistrationStep1> createState() => _RegistrationStep1State();
}

class _RegistrationStep1State extends State<RegistrationStep1> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool isLoading = false;
  String? error;

  final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z]+\.[a-zA-Z]+$');
  final passwordRegex = RegExp(r'^[a-zA-Z0-9!@#\$%^&*()_+{}\[\]:;<>,.?~\\/-]+$');

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      final success = await AuthService.register(
        _emailController.text,
        _passwordController.text,
      );
      setState(() => isLoading = false);

      if (success) {
        widget.data.email = _emailController.text;
        widget.data.password = _passwordController.text;
        widget.onNext();
      } else {
        setState(() => error = 'Registration failed. Try again.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const Text('Create your account', style: TextStyle(fontSize: 22)),
            const SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (val) =>
                  val != null && emailRegex.hasMatch(val) ? null : 'Invalid email format',
            ),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
              validator: (val) =>
                  val != null && passwordRegex.hasMatch(val) && val.length >= 6
                      ? null
                      : 'Only letters/numbers/symbols, min 6 chars',
            ),
            if (error != null) ...[
              const SizedBox(height: 10),
              Text(error!, style: const TextStyle(color: Colors.red)),
            ],
            const Spacer(),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(onPressed: _submit, child: const Text('Next')),
          ],
        ),
      ),
    );
  }
}
