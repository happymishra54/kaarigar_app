import 'package:flutter/material.dart';

import '../services/profile_service.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileService _service = ProfileService();

  bool loading = false;

  Map<String, dynamic>? user;

  Future<void> loadProfile(String token) async {
    loading = true;
    notifyListeners();

    try {
      user = await _service.getProfile(token);
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<bool> update({
    required String token,
    required String name,
    required String email,
    required String phone,
  }) async {
    loading = true;
    notifyListeners();

    try {
      return await _service.updateProfile(
        token: token,
        name: name,
        email: email,
        phone: phone,
      );
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}