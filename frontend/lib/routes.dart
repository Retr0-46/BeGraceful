import 'package:flutter/material.dart';
import 'package:frontend/src/ui/screens/profile/profile_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/profile': (context) => const ProfileScreen(),
};