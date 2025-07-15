// lib/src/ui/screens/registration/registration_page.dart
import 'package:flutter/material.dart';
import '../../../models/registration_data.dart';
import 'registration_step1_auth.dart';
import 'registration_step2_profile.dart';
import '../main_navigation.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final RegistrationData _data = RegistrationData();
  int step = 0;

  void _next() => setState(() => step++);
  void _finish() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainNavigation()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: step == 0
          ? RegistrationStep1(data: _data, onNext: _next)
          : RegistrationStep2(data: _data, onFinish: _finish),
    );
  }
}
