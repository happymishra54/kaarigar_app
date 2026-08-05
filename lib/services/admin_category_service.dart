import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../config/api.dart';
import '../models/admin_category_model.dart';

class AdminCategoryService {
  final storage = const FlutterSecureStorage();

  Future<String> _token() async {
    final token = await storage.read(key: "token");

    if (token == null) {
      throw Exception("Not logged in");
    }

    return token;
  }

  Future<List<AdminCategory>> getCategories() async {
    final token = await _token();

    final response = await http.get(
      Uri.parse(Api.adminCategories),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final List list = data["categories"];

      return list
          .map((e) => AdminCategory.fromJson(e))
          .toList();
    }

    throw Exception(data["message"] ?? "Unable to load categories");
  }

  Future<void> addCategory({
    required String name,
    required String description,
  }) async {
    final token = await _token();

    final response = await http.post(
      Uri.parse(Api.adminCategories),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
      body: {
        "name": name,
        "description": description,
      },
    );

    if (response.statusCode != 200 &&
        response.statusCode != 201) {
      throw Exception("Unable to create category");
    }
  }

  Future<void> updateCategory({
    required int id,
    required String name,
    required String description,
  }) async {
    final token = await _token();

    final response = await http.put(
      Uri.parse("${Api.adminCategories}/$id"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
      body: {
        "name": name,
        "description": description,
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Unable to update category");
    }
  }

  Future<void> deleteCategory(int id) async {
    final token = await _token();

    final response = await http.delete(
      Uri.parse("${Api.adminCategories}/$id"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Unable to delete category");
    }
  }

  Future<void> toggleStatus(int id) async {
    final token = await _token();

    final response = await http.patch(
      Uri.parse("${Api.adminCategories}/$id/status"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Unable to update category status");
    }
  }
}