import 'package:flutter/material.dart';
import '../models/activity.dart';
import '../services/activity_service.dart';

class ActivityProvider extends ChangeNotifier {
  List<Activity> _activities = [];
  Activity? _selected;
  int _duration = 0;

  List<Activity> get activities => _activities;
  Activity? get selected => _selected;
  int get duration => _duration;

  double get burnedCalories =>
      _selected != null ? _selected!.caloriesPerMinute * _duration : 0;

  Future<void> loadActivities() async {
    _activities = await ActivityService.fetchActivities();
    notifyListeners();
  }

  void selectActivity(Activity activity) {
    _selected = activity;
    notifyListeners();
  }

  void setDuration(int minutes) {
    _duration = minutes;
    notifyListeners();
  }
}
