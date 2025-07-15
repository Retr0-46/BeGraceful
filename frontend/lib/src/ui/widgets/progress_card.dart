import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class ProgressCard extends StatelessWidget {
  final int consumed;
  final int burned;
  final int remaining;

  const ProgressCard({
    super.key,
    required this.consumed,
    required this.burned,
    required this.remaining,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: kPrimaryGradient,
        borderRadius: BorderRadius.circular(kCardRadius),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Progress 📊', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildItem('Consumed', consumed.toString(), Colors.white),
              _buildItem('Remaining', remaining.toString(), Colors.white),
              _buildItem('Burned', burned.toString(), Colors.white),
            ],
          ),
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
}
