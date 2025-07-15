import 'package:flutter/material.dart';
import '../../../models/home_page/meal.dart';
import '../../../models/home_page/food_item.dart';
import 'add_food_dialog.dart';

class MealsCard extends StatelessWidget {
  final List<Meal> meals;
  final List<FoodItem> allFoodItems;
  final void Function(Meal) onMealUpdated;

  const MealsCard({
    super.key,
    required this.meals,
    required this.allFoodItems,
    required this.onMealUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Meals', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...meals.map((meal) => _buildMealTile(context, meal)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildMealTile(BuildContext context, Meal meal) {
    final totalCalories = meal.entries.fold(0, (sum, e) => sum + e.calories);
    final totalProtein = meal.entries.fold(0.0, (sum, e) => sum + e.proteins);
    final totalFat = meal.entries.fold(0.0, (sum, e) => sum + e.fats);
    final totalCarbs = meal.entries.fold(0.0, (sum, e) => sum + e.carbs);

    return ExpansionTile(
      title: Text(meal.type, style: const TextStyle(fontWeight: FontWeight.bold)),
      trailing: TextButton(
        onPressed: () async {
          final result = await showDialog<FoodItem>(
            context: context,
            builder: (context) => AddFoodDialog(
              mealType: meal.type,
              allFoodItems: allFoodItems,
            ),
          );

          if (result != null) {
            meal.entries.add(MealEntry(
              name: result.name,
              calories: result.calories,
              proteins: result.protein,
              fats: result.fat,
              carbs: result.carbs,
            ));
            onMealUpdated(meal);
          }
        },
        child: const Text('+ Add'),
      ),
      children: [
        if (meal.entries.isEmpty)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('No items added yet.'),
          ),
        ...meal.entries.map((e) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${e.name} x1'),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('${e.calories} kcal'),
                      Text('P: ${e.proteins}g  F: ${e.fats}g  C: ${e.carbs}g', style: const TextStyle(fontSize: 10)),
                    ],
                  ),
                ],
              ),
            )),
        if (meal.entries.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total:', style: TextStyle(fontWeight: FontWeight.bold)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('$totalCalories kcal', style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('P: ${totalProtein}g  F: ${totalFat}g  C: ${totalCarbs}g', style: const TextStyle(fontSize: 10)),
                  ],
                ),
              ],
            ),
          ),
        const Divider(),
      ],
    );
  }
}
