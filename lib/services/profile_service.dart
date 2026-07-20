import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api.dart';

class ProfileService {
  Future<Map<String, dynamic>> getProfile(String token) async {
    final response = await http.get(
      Uri.parse(Api.profile),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data["user"];
    }

    throw Exception(
      data["message"] ?? "Failed to load profile",
    );
  }

  Future<bool> updateProfile({
    required String token,
    required String name,
    required String email,
    required String phone,
  }) async {
    final response = await http.put(
      Uri.parse(Api.profile),
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

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return true;
    }

    throw Exception(
      data["message"] ?? "Profile update failed",
    );
  }
}