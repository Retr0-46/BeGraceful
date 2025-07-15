import 'package:flutter/material.dart';
import 'package:frontend/src/models/registration_data.dart';
import 'package:frontend/src/ui/widgets/profile_page/user_info_card.dart';
import 'package:frontend/src/ui/widgets/profile_page/progress_card.dart';
import 'package:frontend/src/ui/widgets/profile_page/daily_goal_card.dart';
import 'package:frontend/src/ui/widgets/profile_page/account_card.dart';
import 'package:frontend/src/storage/user_temp_storage.dart';
import 'package:frontend/src/mock_data.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late RegistrationData user;
  late double currentWeight;

  @override
  void initState() {
    super.initState();
    user = UserTempStorage.user!; 
    currentWeight = user.weight ?? 0; 
  }
    void _updateWeight(double newWeight) {
    setState(() {
      user.weight = newWeight;
      UserTempStorage.updateWeight(newWeight); 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color(0xFF5371F4),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            UserInfoCard(user: user),
            ProgressCard(
              user: user,
              currentWeight: currentWeight,
              onWeightUpdated: _updateWeight,
            ),
            const DailyGoalCard(),
            AccountCard(
              onProfileEdited: (updatedUser) {
                setState(() {
                  user = updatedUser;
                  currentWeight = updatedUser.weight ?? currentWeight;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}