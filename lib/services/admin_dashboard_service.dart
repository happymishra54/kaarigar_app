import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../config/api.dart';

class AdminDashboardService {
  final FlutterSecureStorage storage =
      const FlutterSecureStorage();

  Future<Map<String, dynamic>> getDashboard() async {
    final token = await storage.read(key: "token");

    final response = await http.get(
      Uri.parse(Api.adminDashboard),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data["stats"];
    }

    throw Exception(
      data["message"] ?? "Unable to load dashboard",
    );
  }
}