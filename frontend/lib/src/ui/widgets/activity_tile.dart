import 'package:flutter/material.dart';
import '../../models/activity.dart';

class ActivityTile extends StatelessWidget {
  final Activity activity;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const ActivityTile({
    super.key,
    required this.activity,
    this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        leading: const Icon(Icons.fitness_center),
        title: Text(activity.name),
        subtitle: Text('${activity.caloriesBurned.toStringAsFixed(0)} kcal'),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
