import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/src/providers/theme_provider.dart';
import 'src/ui/themes/app_theme.dart';
import 'src/ui/screens/start_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'BeGraceful',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const StartPage(),
    );
  }
}
