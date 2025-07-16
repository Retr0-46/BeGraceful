import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/meal_provider.dart';
import '../../providers/day_provider.dart';
import '../../models/home_page/day_summary.dart';
import '../widgets/home_page/progress_card.dart';
import '../widgets/home_page/meals_card.dart';
import '../../models/home_page/meal.dart';
import '../../models/home_page/activity.dart';
import '../widgets/home_page/activities_card.dart';
import '../widgets/home_page/step_card.dart';
import '../widgets/home_page/add_activity_dialog.dart';
import 'package:intl/intl.dart';
import '../../services/auth_service.dart';
import '../../providers/user_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final userId = userProvider.userId;
      if (userId != null) {
        Provider.of<DayProvider>(context, listen: false).initStepTracking(userId);
      }
      context.read<DayProvider>().loadDayData();
    });
  }

  @override
  void dispose() {
    Provider.of<DayProvider>(context, listen: false).disposeStepTracking();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final foodProvider = Provider.of<FoodProvider>(context);
    final dayProvider = Provider.of<DayProvider>(context);

    print('FoodProvider: isLoading= [32m${foodProvider.isLoading} [0m, items=${foodProvider.foodItems.length}');

    if (foodProvider.isLoading || dayProvider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (foodProvider.error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Food Error: ${foodProvider.error}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => foodProvider.loadFoodItems(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (dayProvider.error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Day Error: ${dayProvider.error}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => dayProvider.loadDayData(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    // Собираем DaySummary для расчётов
    final daySummary = dayProvider.currentDay;

    return Scaffold(
      appBar: AppBar(title: const Text('BeGraceful')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ProgressCard(
              summary: daySummary,
              onHistoryPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    final days = dayProvider.days.values.toList()
                      ..sort((a, b) => b.date.compareTo(a.date));
                    return AlertDialog(
                      title: const Text('History'),
                      content: SizedBox(
                        width: 350,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: days.length,
                          itemBuilder: (context, index) {
                            final d = days[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: ProgressCard(
                                summary: d,
                                onHistoryPressed: null, // не показываем кнопку истории внутри истории
                              ),
                            );
                          },
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            MealsCard(
              meals: daySummary.meals,
              allFoodItems: foodProvider.foodItems,
              onMealUpdated: (meal) async {
                // Обновляем прием пищи через DayProvider
                await dayProvider.updateMeal(meal);
              },
            ),
            const SizedBox(height: 16),
            ActivitiesCard(
              activities: daySummary.activities,
              onAddActivity: () async {
                final newActivity = await showDialog<Activity>(
                  context: context,
                  builder: (context) => const AddActivityDialog(),
                );

                if (newActivity != null) {
                  await dayProvider.addActivity(newActivity);
                }
              },
            ),
            const SizedBox(height: 16),
            StepsCard(
              steps: daySummary.steps,
              caloriesBurned: daySummary.stepsCalories,
            ),
          ],
        ),
      ),
    );
  }
}
