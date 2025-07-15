import 'package:flutter/material.dart';
import 'package:frontend/src/models/registration_data.dart';
import 'package:intl/intl.dart'; // для форматирования даты

class UserInfoCard extends StatelessWidget {
  final RegistrationData user;

  const UserInfoCard({super.key, required this.user});

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
    final birth = user.birthDate;
    final age = birth != null ? _calculateAge(birth) : null;
    final birthFormatted = birth != null ? DateFormat('dd.MM.yyyy').format(birth) : 'Unknown';

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

            _buildLine('Name: ', user.username),
            _buildLine('Birth Date: ', birth != null ? '$birthFormatted ($age years)' : null),
            _buildLine('Sex: ', user.gender),
            _buildLine('Current weight: ', user.weight != null ? '${user.weight!.toStringAsFixed(1)} kg' : null),
            _buildLine('Height: ', user.height != null ? '${user.height!.toStringAsFixed(1)} sm' : null),
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