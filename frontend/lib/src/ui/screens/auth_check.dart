import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/start_page.dart';
import '../screens/main_navigation.dart';
import '../../providers/user_provider.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  bool _isLoading = true;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    // Check if JWT exists
    final jwt = ApiService.getJwt();
    if (jwt != null) {
      // Try to load profile to verify JWT is valid
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      // Extract userId from JWT
      final userId = AuthService.getUserIdFromJwt(jwt);
      if (userId != null) {
        userProvider.setUserId(userId);
      }
      try {
        await userProvider.loadProfile();
        if (userProvider.profile != null) {
          setState(() {
            _isAuthenticated = true;
            _isLoading = false;
          });
          return;
        }
      } catch (e) {
        // JWT is invalid, clear it
        ApiService.setJwt(null);
        userProvider.logout();
      }
    }
    
    setState(() {
      _isAuthenticated = false;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return _isAuthenticated ? const MainNavigation() : const StartPage();
  }
} 