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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(meal.type, style: const TextStyle(fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () async {
                final result = await showDialog<FoodItem>(
                  context: context,
                  builder: (context) => AddFoodDialog(
                    mealType: meal.type,
                    allFoodItems: allFoodItems,
                  ),
                );
                if (result != null) {
                  final newEntry = MealEntry(
                    name: result.name,
                    calories: result.calories,
                    proteins: result.protein,
                    fats: result.fat,
                    carbs: result.carbs,
                    mealType: meal.type,
                  );
                  final updatedEntries = List<MealEntry>.from(meal.entries)..add(newEntry);
                  final updatedMeal = Meal(type: meal.type, entries: updatedEntries);
                  onMealUpdated(updatedMeal);
                }
              },
              child: const Text('+ Add'),
            ),
          ],
        ),
        if (meal.entries.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text('No items added yet', style: TextStyle(color: Colors.grey)),
          ),
        ...meal.entries.map((e) => Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: ListTile(
                title: Text(e.name, style: const TextStyle(fontWeight: FontWeight.w500)),
                subtitle: Text('${e.calories} kcal, P: ${e.proteins.toStringAsFixed(2)}g, F: ${e.fats.toStringAsFixed(2)}g, C: ${e.carbs.toStringAsFixed(2)}g'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    final updatedEntries = List<MealEntry>.from(meal.entries)
                      ..removeWhere((entry) => entry.name == e.name);
                    final updatedMeal = Meal(type: meal.type, entries: updatedEntries);
                    onMealUpdated(updatedMeal);
                  },
                ),
              ),
            )),
        if (meal.entries.isNotEmpty)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total:', style: TextStyle(fontWeight: FontWeight.bold)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('$totalCalories kcal', style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _buildNutrientChip('P', totalProtein, Colors.red),
                        const SizedBox(width: 8),
                        _buildNutrientChip('F', totalFat, Colors.orange),
                        const SizedBox(width: 8),
                        _buildNutrientChip('C', totalCarbs, Colors.blue),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildNutrientChip(String label, double value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        '$label: ${value.toStringAsFixed(1)}g',
        style: TextStyle(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
