import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/src/providers/theme_provider.dart';
import 'src/ui/themes/app_theme.dart';
import 'src/ui/screens/start_page.dart';
import 'package:frontend/routes.dart';
import 'package:frontend/src/ui/screens/profile/profile_screen.dart';
import 'package:frontend/src/ui/screens/main_navigation.dart';

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
      routes: appRoutes,
      initialRoute: '/', 
      //home: const ProfileScreen(), // не забыть обратно поменять на const StartPage()
      home: const MainNavigation(),
    );
  }
}
