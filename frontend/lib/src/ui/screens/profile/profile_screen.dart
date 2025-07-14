import 'package:flutter/material.dart';
import 'package:frontend/src/ui/widgets/profile_page/user_info_card.dart';
import 'package:frontend/src/ui/widgets/profile_page/progress_card.dart';
import 'package:frontend/src/ui/widgets/profile_page/daily_goal_card.dart';
import 'package:frontend/src/ui/widgets/profile_page/account_card.dart';
import 'package:frontend/src/models/registration_data.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
final demoUser = RegistrationData()
  ..username = 'Ivan'
  ..gender = 'Male'
  ..birthDate = DateTime(2006, 11, 4)
  ..height = 185
  ..weight = 96 // start weight from registartion
  ..goal = 'To lose weight'
  ..goalWeight = 82;

final double currentWeight = 90;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
            children: [
            SizedBox(height: 16),
            UserInfoCard(user: demoUser),
            ProgressCard(user: demoUser, currentWeight: currentWeight),
            DailyGoalCard(),
            AccountCard(),
    ],
  ),
),
    );
  }
}