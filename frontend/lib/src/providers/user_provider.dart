import 'package:flutter/material.dart';
import '../services/profile_service.dart';

class UserProvider extends ChangeNotifier {
  Map<String, dynamic>? profile;
  String? _userId;
  bool _isLoading = false;
  String? _error;

  String? get userId => _userId;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void setUserId(String userId) {
    _userId = userId;
    notifyListeners();
  }

  Future<void> loadProfile() async {
    if (_userId == null) return;
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      profile = await ProfileService.getProfile(_userId!);
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    if (_userId == null) return;
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await ProfileService.updateProfile(data);
      await loadProfile();
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateWeight(int weightKg) async {
    if (_userId == null) return;
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await ProfileService.updateWeight(_userId!, weightKg);
      await loadProfile();
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchProfile() async {
    if (userId == null) return;
    try {
      final profileData = await ProfileService.getProfile(userId!);
      profile = profileData;
      notifyListeners();
    } catch (e) {
      // Можно обработать ошибку
    }
  }

  void logout() {
    _userId = null;
    profile = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
} 