import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/ui/screens/auth_check.dart';
import 'src/providers/user_provider.dart';
import 'src/providers/theme_provider.dart';
import 'src/providers/meal_provider.dart';
import 'src/providers/day_provider.dart';
import 'src/ui/themes/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => FoodProvider()),
        ChangeNotifierProvider(create: (_) => DayProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'BeGraceful',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const AuthCheck(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
