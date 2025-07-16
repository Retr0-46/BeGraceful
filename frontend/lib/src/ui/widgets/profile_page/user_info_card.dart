import 'package:flutter/material.dart';
import 'package:frontend/src/models/registration_data.dart';
import 'package:intl/intl.dart'; // для форматирования даты

class UserInfoCard extends StatelessWidget {
  final Map<String, dynamic> user;
  final double currentWeight;

  const UserInfoCard({super.key, required this.user, required this.currentWeight});

  int _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month || (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    final birth = user['date_of_birth'];
    DateTime? birthDate;
    int? age;
    String birthFormatted = 'Unknown';
    
    if (birth != null) {
      try {
        birthDate = DateTime.parse(birth);
        age = _calculateAge(birthDate);
        birthFormatted = DateFormat('dd.MM.yyyy').format(birthDate);
      } catch (e) {
        print('Error parsing birth date: $birth, error: $e');
      }
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'User Information ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 2),
                Image.asset(
                  'assets/images/profile_page/user_information_icon.png',
                  height: 20,
                  alignment: Alignment.bottomCenter,
                ),
              ],
            ),
            const SizedBox(height: 12),

            _buildLine('Name: ', user['first_name'] ?? user['username'] ?? ''),
            _buildLine('Birth Date: ', birthFormatted),
            _buildLine('Sex: ', user['gender'] ?? ''),
            _buildLine('Current weight: ', '${currentWeight.toStringAsFixed(1)} kg'),
            _buildLine('Height: ', user['height_cm']?.toString() ?? user['height']?.toString() ?? ''),
          ],
        ),
      ),
    );
  }

  Widget _buildLine(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 16, color: Color(0xFF4B5563)),
          children: [
            TextSpan(text: label, style: const TextStyle(fontWeight: FontWeight.w600)),
            TextSpan(text: value ?? '—'),
          ],
        ),
      ),
    );
  }
}