import 'package:flutter/material.dart';

class UserInfoCard extends StatelessWidget {
  const UserInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Row(
              children: [
                Text(
                  'User Information ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.person),
              ],
            ),
            SizedBox(height: 12),
            Text('Name: Ivan'),
            Text('Birth Date: 04.11.2006 (18 years)'),
            Text('Sex: Male'),
            Text('Current Weight: 90 kg'),
            Text('Height: 185 sm'),
          ],
        ),
      ),
    );
  }
}