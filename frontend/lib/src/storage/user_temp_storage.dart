import 'package:frontend/src/models/registration_data.dart';

class UserTempStorage {
  static RegistrationData? _user;
  static double? _currentWeight;

  static RegistrationData? get user => _user;
  static double get currentWeight => _currentWeight ?? _user?.weight ?? 0;

  static void setUser(RegistrationData user) {
    _user = user;
    _currentWeight = user.weight; 
  }

  static void updateWeight(double newWeight) {
    _currentWeight = newWeight;
  }
}