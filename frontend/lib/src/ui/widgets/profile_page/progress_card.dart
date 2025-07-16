import 'package:flutter/material.dart';

class ProgressCard extends StatefulWidget {
  final Map<String, dynamic> user;
  final double currentWeight; 
  final void Function(double newWeight)? onWeightUpdated;

  const ProgressCard({
    super.key,
    required this.user,
    required this.currentWeight,
    this.onWeightUpdated,
  });

  @override
  State<ProgressCard> createState() => _ProgressCardState();
}

class _ProgressCardState extends State<ProgressCard> {
  late double currentWeight;

  @override
  void initState() {
    super.initState();
    currentWeight = widget.currentWeight;
  }

  @override
  void didUpdateWidget(ProgressCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentWeight != widget.currentWeight) {
      setState(() {
        currentWeight = widget.currentWeight;
      });
    }
  }

  void _showUpdateDialog() async {
    final controller = TextEditingController();

    final newWeight = await showDialog<double>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Weight'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Enter new weight (kg)'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final value = double.tryParse(controller.text);
                if (value != null) {
                  Navigator.of(context).pop(value);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (newWeight != null) {
      widget.onWeightUpdated?.call(newWeight);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double? start = (widget.user['weight_kg'] as num?)?.toDouble() ?? (widget.user['weight'] as num?)?.toDouble();
    final double? goal = (widget.user['goal_weight_kg'] as num?)?.toDouble() ?? (widget.user['goal_weight'] as num?)?.toDouble();

    double progress = 0;
    double alreadyLost = 0;
    double totalToLose = 0;

    if (start != null && goal != null) {
      alreadyLost = (start - currentWeight).clamp(0, double.infinity);
      totalToLose = (start - goal).clamp(0, double.infinity);
      progress = totalToLose > 0 ? (alreadyLost / totalToLose).clamp(0.0, 1.0) : 0;
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
                  'Progress ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 2),
                Image.asset(
                  'assets/images/profile_page/progress_icon.png',
                  height: 20,
                  alignment: Alignment.bottomCenter,
                ),
              ],
            ),
            const SizedBox(height: 12),
            RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 16, color: Color(0xFF4B5563)),
                children: [
                  const TextSpan(
                    text: 'Goal: ',
                    style: TextStyle(fontWeight: FontWeight.w600), 
                  ),
                  TextSpan(
                    text: widget.user['goal'] ?? '—',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Column(
                children: [
                  Text(
                    'You have already lost ${alreadyLost.toStringAsFixed(1)} kg!',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF000000), 
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 0),
                  const Text(
                    'Keep up the good work!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF4B5563), 
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${start?.toInt()} kg', style: const TextStyle(color: Color(0xFF4B5563))),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                      color: const Color(0xFF22C55E),
                      backgroundColor: Colors.grey[300],
                    ),
                  ),
                ),
                Text('${goal?.toInt()} kg', style: const TextStyle(color: Color(0xFF4B5563))),
              ],
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                '${currentWeight.toStringAsFixed(1)} kg',
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: ElevatedButton.icon(
                onPressed: _showUpdateDialog,
                icon: Image.asset(
                  'assets/images/profile_page/update_weight_icon.png',
                  height: 20,
                ),
                label: const Text('Update Weight'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5371F4),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}