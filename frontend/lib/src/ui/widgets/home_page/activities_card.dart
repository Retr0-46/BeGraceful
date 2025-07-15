import 'package:flutter/material.dart';
import '../../../models/home_page/activity.dart';

class ActivitiesCard extends StatelessWidget {
  final List<Activity> activities;
  final void Function()? onAddActivity;

  const ActivitiesCard({
    super.key,
    required this.activities,
    this.onAddActivity,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Activities', style: TextStyle(fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: onAddActivity,
                  child: const Text('+ Add Activity'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...activities.map((activity) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(activity.name),
                    Row(
                      children: [
                        Text('${activity.durationMinutes} min'),
                        const SizedBox(width: 10),
                        Text(
                          '-${activity.caloriesBurned} kcal',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
