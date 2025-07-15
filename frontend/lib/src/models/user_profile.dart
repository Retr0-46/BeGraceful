class UserProfile {
  final String name;
  final String email;
  final String sex; // "Male" или "Female"
  final DateTime birthDate;
  final double height; // в см
  final double weight; // в кг
  final String activityLevel; // "Sedentary", "Lightly Active", ...
  final String goal; // "Lose weight", "Maintain weight", ...
  final double goalWeight;

  // Цели по питательным веществам (могут быть вручную заданы)
  final int caloriesGoal;
  final int proteinGoal; // в граммах
  final int fatGoal;     // в граммах
  final int carbsGoal;   // в граммах

  final bool customGoals;

  UserProfile({
    required this.name,
    required this.email,
    required this.sex,
    required this.birthDate,
    required this.height,
    required this.weight,
    required this.activityLevel,
    required this.goal,
    required this.goalWeight,
    required this.caloriesGoal,
    required this.proteinGoal,
    required this.fatGoal,
    required this.carbsGoal,
    this.customGoals = false,
  });

  /// Фабрика: автоматически рассчитывает цели
  factory UserProfile.withCalculatedGoals({
    required String name,
    required String email,
    required String sex,
    required DateTime birthDate,
    required double height,
    required double weight,
    required String activityLevel,
    required String goal,
    required double goalWeight,
  }) {
    final goals = _calculateNutritionGoals(
      weight: weight,
      height: height,
      sex: sex,
      age: _calculateAge(birthDate),
      activityLevel: activityLevel,
      goal: goal,
    );

    return UserProfile(
      name: name,
      email: email,
      sex: sex,
      birthDate: birthDate,
      height: height,
      weight: weight,
      activityLevel: activityLevel,
      goal: goal,
      goalWeight: goalWeight,
      caloriesGoal: goals['calories']!,
      proteinGoal: goals['protein']!,
      fatGoal: goals['fat']!,
      carbsGoal: goals['carbs']!,
      customGoals: false,
    );
  }

  static int _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month || (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  static Map<String, int> _calculateNutritionGoals({
    required double weight,
    required double height,
    required String sex,
    required int age,
    required String activityLevel,
    required String goal,
  }) {
    // Формула Маффина-Джеора
    double bmr = (sex == "Male")
        ? 10 * weight + 6.25 * height - 5 * age + 5
        : 10 * weight + 6.25 * height - 5 * age - 161;

    double activityMultiplier = {
      'Sedentary': 1.2,
      'Lightly Active': 1.375,
      'Moderately Active': 1.55,
      'Very Active': 1.725,
      'Extra Active': 1.9,
    }[activityLevel] ?? 1.2;

    double maintenanceCalories = bmr * activityMultiplier;

    double adjustedCalories = {
      'Lose weight': maintenanceCalories - 500,
      'Gain weight': maintenanceCalories + 300,
      'Maintain weight': maintenanceCalories,
    }[goal] ?? maintenanceCalories;

    // Макросы: 20% белки, 30% жиры, 50% углеводы
    int calories = adjustedCalories.round();
    int protein = ((calories * 0.2) / 4).round(); // 4 ккал/г
    int fat = ((calories * 0.3) / 9).round();     // 9 ккал/г
    int carbs = ((calories * 0.5) / 4).round();   // 4 ккал/г

    return {
      'calories': calories,
      'protein': protein,
      'fat': fat,
      'carbs': carbs,
    };
  }
}
