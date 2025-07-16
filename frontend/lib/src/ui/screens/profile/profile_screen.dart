import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/src/ui/widgets/profile_page/user_info_card.dart';
import 'package:frontend/src/ui/widgets/profile_page/progress_card.dart';
import 'package:frontend/src/ui/widgets/profile_page/daily_goal_card.dart';
import 'package:frontend/src/ui/widgets/profile_page/account_card.dart';
import 'package:frontend/src/providers/user_provider.dart';
import 'package:frontend/src/ui/screens/profile/edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.userId != null) {
      userProvider.loadProfile();
    }
  }

  void _updateWeight(BuildContext context, double newWeight) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.updateWeight(newWeight.toInt());
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final profile = userProvider.profile;
    if (profile == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: const Center(
          child: Text('Профиль не найден. Пожалуйста, заполните профиль.'),
        ),
      );
    }
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        if (userProvider.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (userProvider.error != null) {
          return Scaffold(
            body: Center(child: Text('Error: \\${userProvider.error}')),
          );
        }
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
                UserInfoCard(
                  user: profile,
                  currentWeight: (profile['current_weight_kg'] as num?)?.toDouble() ?? (profile['weight_kg'] as num?)?.toDouble() ?? 0,
                ),
                ProgressCard(
                  user: profile,
                  currentWeight: (profile['current_weight_kg'] as num?)?.toDouble() ?? (profile['weight_kg'] as num?)?.toDouble() ?? 0,
                  onWeightUpdated: (w) => _updateWeight(context, w),
                ),
                const DailyGoalCard(),
                AccountCard(
                  onProfileEdited: (updatedUser) {
                    userProvider.loadProfile();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}