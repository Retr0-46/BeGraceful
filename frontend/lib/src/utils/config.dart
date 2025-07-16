 import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;

class AppConfig {
  // Определяем хост в зависимости от платформы
  static String get hostIP {
    if (kIsWeb) {
      return 'localhost';
    } else if (Platform.isAndroid) {
      return '10.0.2.2';
    } else {
      return 'localhost';
    }
  }

  // Порт сервисов
  static const int authServicePort = 8001;
  static const int profileServicePort = 8002;
  static const int caloriesServicePort = 8003;

  // Базовые URL для микросервисов
  static String get authServiceUrl => 'http://$hostIP:$authServicePort/api/v1/auth';
  static String get profileServiceUrl => 'http://$hostIP:$profileServicePort/api/v1/profiles';
  static String get caloriesServiceUrl => 'http://$hostIP:$caloriesServicePort/api/v1/calories';

  // Полные URL для сервисов
  static String get authBaseUrl => authServiceUrl;
  static String get profileBaseUrl => profileServiceUrl;
  static String get caloriesBaseUrl => caloriesServiceUrl;
} 
