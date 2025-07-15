class Activity {
  final String id;
  final String name;
  final int durationMinutes;
  final double caloriesPerMinute;

  Activity({
    required this.id,
    required this.name,
    required this.durationMinutes,
    required this.caloriesPerMinute,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      name: json['name'],
      durationMinutes: json['duration_minutes'],
      caloriesPerMinute: (json['calories_per_minute'] as num).toDouble(),
    );
  }

  int get caloriesBurned => (durationMinutes * caloriesPerMinute).round();
}
