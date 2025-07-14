import 'package:flutter/material.dart';

class ProgressCard extends StatelessWidget {
  const ProgressCard({super.key});

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
          children: [
            const Row(
              children: [
                Text(
                  'Progress ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.bar_chart),
              ],
            ),
            const SizedBox(height: 12),
            const Text('Goal: To lose weight'),
            const SizedBox(height: 8),
            const Text(
              'You have already lost 6 kg!\nKeep up the good work!',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('96 kg'),
                const SizedBox(width: 8),
                Expanded(
                  child: LinearProgressIndicator(
                    value: 0.5, // от 0 до 1 — можешь потом заменить на переменную
                    color: Colors.green,
                    backgroundColor: Colors.grey[300],
                  ),
                ),
                const SizedBox(width: 8),
                const Text('82 kg'),
              ],
            ),
            const SizedBox(height: 12),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: добавить логику обновления веса
                },
                icon: const Icon(Icons.edit),
                label: const Text('Update Weight'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigoAccent,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}