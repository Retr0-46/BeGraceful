import 'package:flutter/material.dart';
import '../../../models/home_page/meal.dart';
import '../../../models/home_page/food_item.dart';
import 'add_food_dialog.dart';

class MealsSection extends StatefulWidget {
  final List<Meal> meals;
  final List<FoodItem> allFoodItems;
  final void Function(Meal) onMealUpdated;

  const MealsSection({super.key, required this.meals, required this.allFoodItems, required this.onMealUpdated});

  @override
  State<MealsSection> createState() => _MealsSectionState();
}

class _MealsSectionState extends State<MealsSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.meals.map((meal) {
        return Card(
          child: ExpansionTile(
            title: Text(meal.type),
            children: [
              ...meal.entries.map((e) => ListTile(
                title: Text(e.name),
                subtitle: Text('${e.calories} kcal – P: ${e.proteins.toStringAsFixed(1)} F: ${e.fats.toStringAsFixed(1)} C: ${e.carbs.toStringAsFixed(1)}'),
              )),
              TextButton(
                onPressed: () async {
                  final result = await showDialog<FoodItem>(
                    context: context,
                    builder: (context) => AddFoodDialog(
                      mealType: meal.type,
                      allFoodItems: widget.allFoodItems,
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
                    // Создаём новый список и новый Meal
                    final updatedEntries = List<MealEntry>.from(meal.entries)..add(newEntry);
                    final updatedMeal = Meal(type: meal.type, entries: updatedEntries);
                    widget.onMealUpdated(updatedMeal);
                  }
                },
                child: const Text('+ Add'),
              )
            ],
          ),
        );
      }).toList(),
    );
  }
}
