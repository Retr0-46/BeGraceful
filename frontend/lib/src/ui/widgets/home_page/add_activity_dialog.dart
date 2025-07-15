import 'package:flutter/material.dart';
import '../../../models/home_page/activity.dart';

class AddActivityDialog extends StatefulWidget {
  const AddActivityDialog({super.key});

  @override
  State<AddActivityDialog> createState() => _AddActivityDialogState();
}

class _AddActivityDialogState extends State<AddActivityDialog> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController caloriesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Add Activity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Activity Name'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: durationController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Duration (minutes)'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: caloriesController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Calories per minute'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  final name = nameController.text;
                  final duration = int.tryParse(durationController.text) ?? 0;
                  final calPerMin = double.tryParse(caloriesController.text) ?? 0.0;

                  if (name.isNotEmpty && duration > 0 && calPerMin > 0) {
                    final activity = Activity(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: name,
                      durationMinutes: duration,
                      caloriesPerMinute: calPerMin,
                    );
                    Navigator.of(context).pop(activity);
                  }
                },
                child: const Text('Add Activity'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
