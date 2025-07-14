import 'package:flutter/material.dart';
import 'package:frontend/src/models/registration_data.dart';

class EditProfileScreen extends StatelessWidget {
  final RegistrationData user;

  const EditProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: const Center(
        child: Text('Edit profile screen'),
      ),
    );
  }
}