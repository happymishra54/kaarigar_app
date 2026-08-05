import 'package:flutter/material.dart';

import '../models/admin_user_model.dart';
import '../services/admin_user_service.dart';

class AdminUserProvider extends ChangeNotifier {
  final AdminUserService _service = AdminUserService();

  bool loading = false;

  List<AdminUser> users = [];

  Future<void> loadUsers() async {
    loading = true;
    notifyListeners();

    users = await _service.getUsers();

    loading = false;
    notifyListeners();
  }

  Future<void> toggleStatus(int id) async {
  await _service.toggleStatus(id);
}

Future<void> deleteUser(int id) async {
  await _service.deleteUser(id);
}

Future<void> updateUser({
  required int id,
  required String name,
  required String email,
  required String phone,
}) async {
  await _service.updateUser(
    id: id,
    name: name,
    email: email,
    phone: phone,
  );
}

}