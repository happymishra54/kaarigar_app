import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../config/api.dart';

class AuthService {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<bool> isLoggedIn() async {
    return await storage.read(key: 'token') != null;
  }

  Future<Map<String, dynamic>> login({
    required String login,
    required String password,
    required String role,
    }) async {
    final response = await http.post(
      Uri.parse(Api.login),
      headers: {
        'Accept': 'application/json',
      },
      body: {
        'login': login,
        'password': password,
        'role': role,
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      await storage.write(
        key: 'token',
        value: data['token'],
      );

      await storage.write(
        key: 'user_id',
        value: data['user']['id'].toString(),
      );

      await storage.write(
        key: 'role',
        value: data['user']['role'],
      );

      await storage.write(
        key: 'name',
        value: data['user']['name'],
      );

      await storage.write(
        key: 'email',
        value: data['user']['email'] ?? '',
      );

      await storage.write(
        key: 'phone',
        value: data['user']['phone'] ?? '',
      );

      return data;
    }

    throw Exception(
      data['message'] ?? 'Login Failed',
    );
  }

  Future<Map<String, dynamic>> register({
  required String name,
  required String email,
  required String phone,
  required String password,
  required String confirmPassword,
  required String role,
}) async {

  final response = await http.post(

    Uri.parse(Api.register),

    headers: {
      "Accept": "application/json",
    },

    body: {

      "name": name,

      "email": email,

      "phone": phone,

      "password": password,

      "password_confirmation": confirmPassword,

      "role": role,

    },

  );

  final data = jsonDecode(response.body);

  if (response.statusCode == 201) {

    await storage.write(
      key: "token",
      value: data["token"],
    );

    await storage.write(
      key: "role",
      value: data["user"]["role"],
    );

    await storage.write(
      key: "name",
      value: data["user"]["name"],
    );

    await storage.write(
      key: "email",
      value: data["user"]["email"] ?? "",
    );

    await storage.write(
      key: "phone",
      value: data["user"]["phone"],
    );

    await storage.write(
      key: "user_id",
      value: data["user"]["id"].toString(),
    );

    return data;
  }

  throw Exception(
    data["message"] ?? "Registration Failed",
  );
}

  Future<String?> getToken() async {
    return await storage.read(
      key: 'token',
    );
  }

  Future<String?> getUserId() async {
    return await storage.read(
      key: 'user_id',
    );
  }

  Future<String?> getRole() async {
    return await storage.read(
      key: 'role',
    );
  }

  Future<String?> getName() async {
    return await storage.read(
      key: 'name',
    );
  }

  Future<String?> getEmail() async {
    return await storage.read(
      key: 'email',
    );
  }

  Future<String?> getPhone() async {
    return await storage.read(
      key: 'phone',
    );
  }

  Future<void> logout() async {
    final token = await getToken();

    if (token != null) {
      try {
        await http.post(
          Uri.parse(Api.logout),
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        );
      } catch (_) {
        // Ignore API logout errors and clear local storage anyway.
      }
    }

    await storage.deleteAll();
  }
}