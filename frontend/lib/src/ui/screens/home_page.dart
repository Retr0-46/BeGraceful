import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/meal_provider.dart';
import '../../models/home_page/day_summary.dart';
import '../widgets/home_page/progress_card.dart';
import '../widgets/home_page/meals_card.dart';
import '../../models/home_page/meal.dart';
import '../../models/home_page/activity.dart';
import '../widgets/home_page/activities_card.dart';
import '../widgets/home_page/step_card.dart';
import '../widgets/home_page/add_activity_dialog.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Meal> meals;
  List<Activity> activities = [];
  int steps = 5000; // можно подгрузить реальные шаги

  @override
  void initState() {
    super.initState();

    // Инициализация приёмов пищи
    meals = [
      Meal(type: 'Breakfast'),
      Meal(type: 'Lunch'),
      Meal(type: 'Dinner'),
      Meal(type: 'Snacks'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final foodProvider = Provider.of<FoodProvider>(context);

    if (foodProvider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (foodProvider.error != null) {
      return Scaffold(
        body: Center(child: Text('Error: ${foodProvider.error}')),
      );
    }

    // Собираем DaySummary для расчётов
    final daySummary = DaySummary(
      date: DateTime.now(),
      meals: meals,
      activities: activities,
      steps: steps,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('BeGraceful')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ProgressCard(summary: daySummary),
            const SizedBox(height: 16),
            MealsCard(
              meals: meals,
              allFoodItems: foodProvider.foodItems,
              onMealUpdated: (meal) {
                setState(() {}); // просто обновляем UI, meals уже изменён по ссылке
              },
            ),
            const SizedBox(height: 16),
            ActivitiesCard(
              activities: activities,
              onAddActivity: () async {
                final newActivity = await showDialog<Activity>(
                  context: context,
                  builder: (context) => const AddActivityDialog(),
                );

                if (newActivity != null) {
                  setState(() {
                    activities.add(newActivity);
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            StepsCard(
              steps: steps,
              caloriesBurned: daySummary.stepsCalories,
            ),
          ],
        ),
      ),
    );
  }
}
