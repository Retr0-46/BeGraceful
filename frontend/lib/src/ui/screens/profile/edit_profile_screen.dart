import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/user_provider.dart';
import '../../../services/profile_service.dart';

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic>? user;
  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController weightController;
  late TextEditingController heightController;
  bool isLoading = false;
  String? error;

  @override
  void initState() {
    super.initState();
    final user = widget.user ?? {};
    nameController = TextEditingController(text: user['name'] ?? '');
    emailController = TextEditingController(text: user['email'] ?? '');
    weightController = TextEditingController(text: (user['current_weight_kg'] ?? user['weight_kg'] ?? user['weight'] ?? '').toString());
    heightController = TextEditingController(text: (user['height_cm'] ?? user['height'] ?? '').toString());
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    weightController.dispose();
    heightController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final userId = userProvider.userId;
      if (userId == null) throw Exception('User ID not found');
      final updatedProfile = {
        'user_id': userId,
        'name': nameController.text,
        'email': emailController.text,
        'current_weight_kg': double.tryParse(weightController.text) ?? 0.0,
        'height_cm': double.tryParse(heightController.text) ?? 0.0,
      };
      // Отправка на backend
      await ProfileService.updateProfile(updatedProfile);
      // Обновить профиль в UserProvider
      await userProvider.fetchProfile();
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Профиль успешно обновлён!')),
        );
      }
    } catch (e) {
      setState(() {
        error = 'Ошибка при обновлении профиля: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user ?? {};
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              enabled: false,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: weightController,
              decoration: const InputDecoration(labelText: 'Weight (kg)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: heightController,
              decoration: const InputDecoration(labelText: 'Height (cm)'),
              keyboardType: TextInputType.number,
            ),
            if (error != null) ...[
              const SizedBox(height: 12),
              Text(error!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: isLoading ? null : _saveProfile,
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}