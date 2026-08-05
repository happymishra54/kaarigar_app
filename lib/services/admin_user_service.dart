import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../config/api.dart';
import '../models/admin_user_model.dart';

class AdminUserService {
  final storage = const FlutterSecureStorage();

  Future<String> _token() async {
    final token = await storage.read(key: "token");

    if (token == null) {
      throw Exception("Not logged in");
    }

    return token;
  }

  Future<List<AdminUser>> getUsers() async {
    final token = await _token();

    final response = await http.get(
      Uri.parse(Api.adminUsers),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final List list = data["users"]["data"];

      return list
          .map((e) => AdminUser.fromJson(e))
          .toList();
    }

    throw Exception(data["message"]);
  }

  Future<void> toggleStatus(int id) async {
  final token = await storage.read(key: "token");

  final response = await http.patch(
    Uri.parse("${Api.adminUsers}/$id/status"),
    headers: {
      "Authorization": "Bearer $token",
      "Accept": "application/json",
    },
  );

  if (response.statusCode != 200) {
    throw Exception("Unable to update status");
  }
}

Future<void> deleteUser(int id) async {
  final token = await storage.read(key: "token");

  final response = await http.delete(
    Uri.parse("${Api.adminUsers}/$id"),
    headers: {
      "Authorization": "Bearer $token",
      "Accept": "application/json",
    },
  );

  if (response.statusCode != 200) {
    throw Exception("Unable to delete user");
  }
}

Future<void> updateUser({
  required int id,
  required String name,
  required String email,
  required String phone,
}) async {
  final token = await _token();

  final response = await http.put(
    Uri.parse("${Api.adminUsers}/$id"),
    headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    },
    body: {
      "name": name,
      "email": email,
      "phone": phone,
    },
  );

  if (response.statusCode != 200) {
    final data = jsonDecode(response.body);
    throw Exception(data["message"] ?? "Update failed");
  }
}

}