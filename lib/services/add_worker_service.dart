import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../config/api.dart';

class AddWorkerService {
  final storage = const FlutterSecureStorage();

  Future<String> _token() async {
    final token = await storage.read(key: "token");

    if (token == null) {
      throw Exception("Unauthenticated");
    }

    return token;
  }

  Future<void> createWorker({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String bio,
    required String experience,
    required String dailyWage,
    required String city,
    required String state,
    required String address,
    required String aadhaarNumber,
    File? profileImage,
    File? aadhaarImage,
  }) async {

    final token = await _token();

    final request = http.MultipartRequest(
      "POST",
      Uri.parse(Api.adminWorkers),
    );

    request.headers["Authorization"] = "Bearer $token";
    request.headers["Accept"] = "application/json";

    request.fields["name"] = name;
    request.fields["email"] = email;
    request.fields["password"] = password;
    request.fields["phone"] = phone;

    request.fields["bio"] = bio;
    request.fields["experience"] = experience;
    request.fields["daily_wage"] = dailyWage;

    request.fields["city"] = city;
    request.fields["state"] = state;
    request.fields["address"] = address;

    request.fields["aadhaar_number"] =
        aadhaarNumber;

    if (profileImage != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          "profile_image",
          profileImage.path,
        ),
      );
    }

    if (aadhaarImage != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          "aadhaar_image",
          aadhaarImage.path,
        ),
      );
    }

    final response = await request.send();

    final body =
        await response.stream.bytesToString();

    if (response.statusCode != 201) {

      throw Exception(
        jsonDecode(body)["message"] ??
            "Unable to create worker",
      );

    }
  }
}