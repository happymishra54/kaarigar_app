import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../config/api.dart';
import '../models/admin_verify_worker_model.dart';
import '../models/admin_worker_model.dart';

class AdminWorkerService {
  final storage = const FlutterSecureStorage();

  Future<String> _token() async {
    final token = await storage.read(key: "token");

    if (token == null) {
      throw Exception("Not logged in");
    }

    return token;
  }

  Future<List<AdminWorker>> getWorkers() async {
    final token = await _token();

    final response = await http.get(
      Uri.parse(Api.adminWorkers),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final List workers = data["workers"]["data"];

      return workers
          .map((e) => AdminWorker.fromJson(e))
          .toList();
    }

    throw Exception(data["message"] ?? "Unable to load workers");
  }

  Future<List<AdminVerifyWorker>> getPendingWorkers() async {
    final token = await _token();

    final response = await http.get(
      Uri.parse(Api.pendingWorkers),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final List workers = data["workers"];

      return workers
          .map((e) => AdminVerifyWorker.fromJson(e))
          .toList();
    }

    throw Exception(data["message"] ?? "Unable to load pending workers");
  }

  Future<void> updateWorker({
  required int id,
  required String name,
  required String email,
  required String phone,
  required String city,
  required String experience,
  required String dailyWage,
}) async {

  final token = await _token();

  final response = await http.put(
    Uri.parse("${Api.adminWorkers}/$id"),
    headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    },
    body: {
      "name": name,
      "email": email,
      "phone": phone,
      "city": city,
      "experience": experience,
      "daily_wage": dailyWage,
    },
  );

  if (response.statusCode != 200) {
    throw Exception("Unable to update worker");
  }
}

  Future<void> verifyWorker(int id) async {
    final token = await _token();

    final response = await http.patch(
      Uri.parse("${Api.adminWorkers}/$id/verify"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Unable to verify worker");
    }
  }

  Future<void> deleteWorker(int id) async {
    final token = await _token();

    final response = await http.delete(
      Uri.parse("${Api.adminWorkers}/$id"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Unable to delete worker");
    }
  }

  Future<void> toggleStatus(int id) async {
  final token = await _token();

  final response = await http.patch(
    Uri.parse("${Api.adminWorkers}/$id/status"),
    headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    },
  );

  if (response.statusCode != 200) {
    throw Exception("Unable to update worker status");
  }
}

Future<String> generatePassword(int id) async {
  final token = await _token();
  final response = await http.patch(
    Uri.parse("${Api.adminWorkers}/$id/generate-password"),
    headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    },
  );


  final data = jsonDecode(response.body);

  if (response.statusCode == 200) {
    return data["password"];
  }

  throw Exception(data["message"] ?? "Unable to generate password");
}

}
