import 'package:flutter/material.dart';
import '../screens/registration/registration_page_navigator.dart';
import '../screens/main_navigation.dart';
import '../../providers/user_provider.dart';
import '../../services/auth_service.dart';
import 'package:provider/provider.dart';


class LoginDialog extends StatefulWidget {
  const LoginDialog({super.key});

  @override
  State<LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _error;
  bool _isLoading = false;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      try {
        final result = await AuthService.login(
          _emailController.text,
          _passwordController.text,
        );
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        if (result['jwt'] != null) {
          AuthService.saveJwt(result['jwt']);
          final userId = AuthService.getUserIdFromJwt(result['jwt']);
          if (userId != null) {
            userProvider.setUserId(userId);
            await tryLoadProfileWithRetry(userProvider);
          }
          setState(() => _isLoading = false);
          Navigator.of(context).pop();
          // Navigate to main app after successful login
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const MainNavigation()),
          );
        } else if (result['user_id'] != null && result['status'] == 'INCOMPLETE_PROFILE') {
          userProvider.setUserId(result['user_id']);
          setState(() => _isLoading = false);
          Navigator.of(context).pop();
          // Переход к завершению профиля (например, RegistrationStep2)
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegistrationPage()),
          );
        } else {
          setState(() {
            _isLoading = false;
            _error = 'Login failed: Invalid credentials or incomplete profile.';
          });
        }
      } catch (e) {
        String errorMsg = 'Ошибка входа. Попробуйте ещё раз.';
        final errStr = e.toString();
        if (errStr.contains('INCOMPLETE_PROFILE')) {
          errorMsg = 'Профиль пользователя не найден. Пожалуйста, зарегистрируйтесь или завершите создание профиля.';
        }
        setState(() => _error = errorMsg);
      }
    }
  }

  Future<void> tryLoadProfileWithRetry(UserProvider userProvider, {int retries = 5, Duration delay = const Duration(seconds: 1)}) async {
    for (int i = 0; i < retries; i++) {
      await Future.delayed(delay);
      await userProvider.loadProfile();
      if (userProvider.profile != null) return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header + close icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Welcome Back',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter your email',
                    ),
                    validator: (val) =>
                        val != null && val.contains('@') ? null : 'Enter a valid email',
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                    ),
                    obscureText: true,
                    validator: (val) => val != null && val.length >= 4
                        ? null
                        : 'Min 4 characters',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Gradient button
            GestureDetector(
              onTap: _isLoading ? null : _login,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4B4DE9), Color(0xFFA033DF)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: _isLoading
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text(
                          'Log In',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 16),
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 16),
            // Text below
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account? "),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => const RegistrationPage())
                    );
                  },
                  child: const Text('Sign up here'),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              '💡 Demo: Use any email/password combination to log in',
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
