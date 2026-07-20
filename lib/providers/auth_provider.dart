import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  UserModel? _user;

  String? _token;

  bool _loading = false;

  UserModel? get user => _user;

  String? get token => _token;

  bool get loading => _loading;

  bool get isLoggedIn => _token != null;

  Future<bool> login({
    required String login,
    required String password,
    required String role,
  }) async {
    _loading = true;
    notifyListeners();

    try {
      final data = await _authService.login(
        login: login,
        password: password,
        role: role,
      );

      _token = data['token'];

      _user = UserModel.fromJson(
        data['user'],
      );

      _loading = false;
      notifyListeners();

      return true;
    } catch (e) {
      _loading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<bool> register({

  required String name,

  required String email,

  required String phone,

  required String password,

  required String confirmPassword,

  required String role,

}) async {

  _loading = true;

  notifyListeners();

  try {

    final data = await _authService.register(

      name: name,

      email: email,

      phone: phone,

      password: password,

      confirmPassword: confirmPassword,

      role: role,

    );

    _user = UserModel.fromJson(
      data["user"],
    );

    _loading = false;

    notifyListeners();

    return true;

  } catch (e) {

    _loading = false;

    notifyListeners();

    rethrow;

  }

}

  Future<void> logout() async {
    await _authService.logout();

    _token = null;
    _user = null;

    notifyListeners();
  }
}