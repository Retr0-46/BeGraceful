import 'package:flutter/material.dart';

class FeatureTile extends StatelessWidget {
  final Widget icon;
  final String title;
  final String subtitle;
  final Color color;

  const FeatureTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.3),
        child: icon,
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
    );
  }
}