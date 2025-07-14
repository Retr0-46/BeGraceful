import 'package:frontend/src/models/registration_data.dart';

final demoUser = RegistrationData()
  ..username = 'Ivan'
  ..gender = 'Male'
  ..birthDate = DateTime(2006, 11, 4)
  ..height = 185
  ..weight = 96
  ..goal = 'To lose weight'
  ..goalWeight = 82;