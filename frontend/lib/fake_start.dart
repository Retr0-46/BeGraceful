import 'package:flutter/material.dart';
import 'package:frontend/src/models/registration_data.dart';
import 'package:frontend/src/ui/screens/registration/registration_step2_profile.dart';
import 'package:frontend/src/providers/theme_provider.dart';
import 'src/ui/themes/app_theme.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const TestApp(),
    ),
  );
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'BeGraceful',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: RegistrationStep2(data: RegistrationData(), onFinish: () => print("Done!"),),
    );
  }
}
