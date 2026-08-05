import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../config/api.dart';
import '../models/admin_booking_model.dart';

class AdminBookingService {
  final storage = const FlutterSecureStorage();

  Future<String> _token() async {
    final token = await storage.read(key: "token");

    if (token == null) {
      throw Exception("Not logged in");
    }

    return token;
  }

  Future<List<AdminBooking>> getBookings() async {
    final token = await _token();

    final response = await http.get(
      Uri.parse(Api.adminBookings),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final List bookings = data["bookings"]["data"];

      return bookings
          .map((e) => AdminBooking.fromJson(e))
          .toList();
    }

    throw Exception(data["message"] ?? "Unable to load bookings");
  }

  Future<void> updateStatus({
    required int id,
    required String status,
  }) async {
    final token = await _token();

    final response = await http.patch(
      Uri.parse("${Api.adminBookings}/$id/status"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
      body: {
        "status": status,
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Unable to update booking");
    }
  }

  Future<void> deleteBooking(int id) async {
    final token = await _token();

    final response = await http.delete(
      Uri.parse("${Api.adminBookings}/$id"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Unable to delete booking");
    }
  }
}