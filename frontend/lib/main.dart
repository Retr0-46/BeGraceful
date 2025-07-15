import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/src/providers/theme_provider.dart';
import 'src/ui/themes/app_theme.dart';
import 'src/ui/screens/start_page.dart';
import 'package:frontend/routes.dart';
import 'package:frontend/src/ui/screens/profile/profile_screen.dart';
import 'package:frontend/src/ui/screens/main_navigation.dart';
import 'package:frontend/src/providers/meal_provider.dart';
import 'package:frontend/src/services/meal_service.dart';

import 'package:frontend/fake_start.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(
          create: (_) => FoodProvider(
            // foodService: FoodService(baseUrl: 'https://your-backend.com/api'), // или мок-сервис
            foodService: MockFoodService()
          )..loadFoodItems(),
        ),
      ],
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
      routes: appRoutes,
      initialRoute: '/', 
      // home: const ProfileScreen(), 
      home: const StartPage(), 
      // home: const MainNavigation(),
    );
  }
}
