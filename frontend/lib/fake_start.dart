import 'package:flutter/material.dart';
import 'package:frontend/src/models/registration_data.dart';
import 'package:frontend/src/ui/screens/home_page.dart';
import 'package:frontend/src/ui/screens/registration/registration_step2_profile.dart';
import 'package:frontend/src/providers/theme_provider.dart';
import 'src/ui/themes/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:frontend/src/providers/meal_provider.dart';
import 'package:frontend/src/services/meal_service.dart';
import 'package:frontend/src/models/home_page/food_item.dart';


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

/* void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => FoodProvider(
            foodService: MockFoodService()
            // foodService: FoodService(baseUrl: 'https://your-backend.com/api'),
          )..loadFoodItems(),
        ),
      ],
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
      home: HomePage(),
    );
  }
}
*/
class MockFoodService extends FoodService {
  MockFoodService() : super(baseUrl: '');

  @override
  Future<List<FoodItem>> fetchFoodItems() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      FoodItem(id: '1', name: 'Rice', unit: '100g', calories: 130, protein: 2.7, fat: 0.3, carbs: 28),
      FoodItem(id: '2', name: 'Apple', unit: '1 piece', calories: 52, protein: 0.3, fat: 0.2, carbs: 14),
    ];
  }
}
