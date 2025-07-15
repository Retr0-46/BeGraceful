import 'package:flutter/material.dart';
import '../../../models/home_page/day_summary.dart';
import '../../../utils/constants.dart';

class ProgressCard extends StatelessWidget {
  final DaySummary summary;

  const ProgressCard({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: kPrimaryGradient,
        borderRadius: BorderRadius.circular(kCardRadius),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Progress 📊',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildItem('Consumed', summary.caloriesConsumed.toString(), Colors.white),
              _buildItem('Remaining', summary.caloriesRemaining.toString(), Colors.white),
              _buildItem('Burned', summary.caloriesBurned.toString(), Colors.white),
            ],
          ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ${value.toStringAsFixed(1)} / ${goal.toStringAsFixed(1)} g',
              style: const TextStyle(color: Colors.white, fontSize: 12)),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: (value / goal).clamp(0, 1),
            backgroundColor: Colors.white24,
            color: barColor,
            minHeight: 6,
          ),
        ],
      ),
    );
  }
}
