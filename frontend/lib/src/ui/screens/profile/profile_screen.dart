import 'package:flutter/material.dart';
import 'package:frontend/src/ui/widgets/user_info_card.dart';
import 'package:frontend/src/ui/widgets/progress_card.dart';
import 'package:frontend/src/ui/widgets/daily_goal_card.dart';
import 'package:frontend/src/ui/widgets/account_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
            children: const [
            SizedBox(height: 16),
            UserInfoCard(),
            ProgressCard(),
            DailyGoalCard(),
            AccountCard(),
    ],
  ),
),
    );
  }
}