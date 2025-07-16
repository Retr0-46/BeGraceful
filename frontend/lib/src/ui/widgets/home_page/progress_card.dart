import 'package:flutter/material.dart';
import '../../../models/home_page/day_summary.dart';
import '../../../utils/constants.dart';
import 'package:intl/intl.dart';

class ProgressCard extends StatelessWidget {
  final DaySummary summary;
  final VoidCallback? onHistoryPressed;

  const ProgressCard({super.key, required this.summary, this.onHistoryPressed});

  @override
  Widget build(BuildContext context) {
    final todayStr = DateFormat('yyyy-MM-dd').format(summary.date);
    return Container(
      decoration: BoxDecoration(
        gradient: kPrimaryGradient,
        borderRadius: BorderRadius.circular(kCardRadius),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progress 📊 — $todayStr',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.history, color: Colors.white),
                tooltip: 'History',
                onPressed: onHistoryPressed,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildItem('Consumed', summary.caloriesConsumed.toString(), Colors.white),
              _buildItem('Remaining', summary.caloriesRemaining < 0 ? '0' : summary.caloriesRemaining.toString(), Colors.white),
              _buildItem('Burned', summary.caloriesBurned.toString(), Colors.white),
            ],
          ),
          const SizedBox(height: 8),
          Text('Steps: ${summary.steps}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          const SizedBox(height: 16),
          _buildMacroRow('Carbs', summary.carbs, summary.carbsGoal, Colors.blue),
          _buildMacroRow('Proteins', summary.proteins, summary.proteinsGoal, Colors.green),
          _buildMacroRow('Fats', summary.fats, summary.fatsGoal, Colors.orange),
        ],
      ),
    );
  }

  Widget _buildItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: TextStyle(color: color)),
      ],
    );
  }

  Widget _buildMacroRow(String label, double value, double goal, Color barColor) {
    final safeValue = value < 0 ? 0.0 : value;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ${safeValue.toStringAsFixed(1)} / ${goal.toStringAsFixed(1)} g',
              style: const TextStyle(color: Colors.white, fontSize: 12)),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: (safeValue / goal).clamp(0, 1),
            backgroundColor: Colors.white24,
            color: barColor,
            minHeight: 6,
          ),
        ],
      ),
    );
  }
}
