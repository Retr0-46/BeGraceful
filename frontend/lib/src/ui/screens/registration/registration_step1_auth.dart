import 'package:flutter/material.dart';
import '../../../models/registration_data.dart';
import '../../../services/auth_service.dart';
import 'package:frontend/src/providers/theme_provider.dart';
import '../../themes/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../providers/user_provider.dart';

class RegistrationStep1 extends StatefulWidget {
  final VoidCallback onNext;
  final RegistrationData data;

  const RegistrationStep1({super.key, required this.onNext, required this.data});

  @override
  State<RegistrationStep1> createState() => _RegistrationStep1State();
}

class _RegistrationStep1State extends State<RegistrationStep1> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool isLoading = false;
  String? error;

  final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z]+\.[a-zA-Z]+$');
  final passwordRegex = RegExp(r'^[a-zA-Z0-9!@#\$%^&*()_+{}\[\]:;<>,.?~\\/-]+$');

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      try {
        final result = await AuthService.register(
          _emailController.text,
          _passwordController.text,
        );
        final userId = result['data']?['user_id'];
        if (userId != null) {
          Provider.of<UserProvider>(context, listen: false).setUserId(userId);
          widget.data.email = _emailController.text;
          widget.data.password = _passwordController.text;
          widget.onNext();
        } else {
          setState(() => error = 'Registration failed. Try again.');
        }
      } catch (e) {
        setState(() => error = e.toString());
      }
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).colorScheme.onBackground,
        elevation: 0,
        centerTitle: true,

        title: RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold,),
            children: [
              TextSpan(
                text: 'Welcome to ',
                style: TextStyle(color: Theme.of(context).colorScheme.onBackground,),
              ),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: SvgPicture.asset(
                  'assets/images/BeGraceful.svg',
                  height: 20,
                ),
              ),
            ],
          ),
        ),

        actions: [
          IconButton(
            icon: Image.asset(
              themeProvider.isDarkMode
                  ? 'assets/images/main_page/sun-light-theme.png'
                  : 'assets/images/main_page/moon-dark-theme.png',
              width: 24,
              height: 24,
            ),
            onPressed: () {
              themeProvider.toggleTheme(!themeProvider.isDarkMode);
            },
          ),
        ],
      ),
      
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LinearProgressIndicator(
                  value: 0.5,
                  backgroundColor: Colors.grey,
                  valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
                ),

                const SizedBox(height: 24),
                const Text('Create your account', style: TextStyle(fontSize: 18)),

                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (val) =>
                      val != null && emailRegex.hasMatch(val) ? null : 'Invalid email format',
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                  validator: (val) =>
                      val != null && passwordRegex.hasMatch(val) && val.length >= 6
                          ? null
                          : 'Only letters/numbers/symbols, min 6 chars',
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Confirm Password'),
                  validator: (val) => val == _passwordController.text
                      ? null
                      : 'Passwords do not match',
                ),
                if (error != null) ...[
                  const SizedBox(height: 10),
                  Text(error!, style: const TextStyle(color: Colors.red)),
                ],
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('Next'),
                        ),
                ),
              ],
            )
          )
        )
      ),
    );
  }
}
