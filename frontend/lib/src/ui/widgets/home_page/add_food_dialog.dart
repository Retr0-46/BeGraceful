import 'package:flutter/material.dart';
import '../../../models/home_page/food_item.dart';

class AddFoodDialog extends StatefulWidget {
  final String mealType;
  final List<FoodItem> allFoodItems; // список из бекенда

  const AddFoodDialog({super.key, required this.mealType, required this.allFoodItems});

  @override
  State<AddFoodDialog> createState() => _AddFoodDialogState();
}

class _AddFoodDialogState extends State<AddFoodDialog> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    final filteredItems = widget.allFoodItems.where((item) =>
        item.name.toLowerCase().contains(query.toLowerCase())).toList();

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Add to ${widget.mealType}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Enter the name of food',
              ),
              onChanged: (value) {
                setState(() => query = value);
              },
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  final item = filteredItems[index];
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text('${item.unit} – ${item.calories} kcal\nP: ${item.protein}g F: ${item.fat}g C: ${item.carbs}g'),
                    trailing: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(item);
                      },
                      child: const Text('Add'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
