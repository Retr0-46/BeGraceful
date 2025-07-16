import 'package:flutter/material.dart';
import 'package:frontend/src/models/registration_data.dart';
import 'package:frontend/src/ui/screens/profile/edit_profile_screen.dart';
import 'package:frontend/src/storage/user_temp_storage.dart';
import 'package:provider/provider.dart';
import 'package:frontend/src/providers/user_provider.dart';
import 'package:frontend/src/services/auth_service.dart';
import 'package:frontend/src/ui/screens/start_page.dart';

class AccountCard extends StatelessWidget {
  final void Function(Map<String, dynamic> updatedUser)? onProfileEdited;

const AccountCard({
  super.key,
  this.onProfileEdited,
});

  void _logout(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    // Clear JWT and user data
    AuthService.logout();
    userProvider.logout();
    
    // Navigate to start page
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const StartPage()),
      (route) => false, // Remove all previous routes
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  'Account ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 2),
                Image.asset(
                  'assets/images/profile_page/account_icon.png',
                  height: 20,
                  alignment: Alignment.bottomCenter,
                ),
              ],
            ),
            const SizedBox(height: 12),

Center(
  child: Column(
    children: [
     SizedBox(
  width: 240,
  child: OutlinedButton.icon(
    onPressed: () {
      final user = Provider.of<UserProvider>(context, listen: false).profile;
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => EditProfileScreen(user: user)),
      );
    },
    icon: Image.asset(
      'assets/images/profile_page/edit_icon.png',
      height: 20,
    ),
    label: const Text(
      'Edit Information',
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
    ),
    style: OutlinedButton.styleFrom(
      backgroundColor: Colors.white,
      side: const BorderSide(color: Color(0xFFE5E7EB)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12),
    ),
  ),
),

      const SizedBox(height: 12),

      // Log Out
      SizedBox(
        width: 240,
        child: ElevatedButton.icon(
          onPressed: () => _logout(context),
          icon: Image.asset(
            'assets/images/profile_page/logout_icon.png',
            height: 20,
          ),
          label: const Text('Log Out'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF87171),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    ],
  ),
),
          ],
        ),
      ),
    );
  }
}