import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api.dart';
import '../models/booking_model.dart';
import '../models/worker_dashboard_model.dart';

class WorkerService {
  Future<WorkerDashboardModel> dashboard(String token) async {
    final response = await http.get(
      Uri.parse(Api.workerDashboard),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Unable to load dashboard");
    }

    return WorkerDashboardModel.fromJson(
      jsonDecode(response.body)["stats"],
    );
  }

  Future<List<BookingModel>> bookings(String token) async {
    final response = await http.get(
      Uri.parse(Api.workerBookings),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Unable to load bookings");
    }

    final data = jsonDecode(response.body);

    return (data["bookings"] as List)
        .map((e) => BookingModel.fromJson(e))
        .toList();
  }

  Future<void> accept(int bookingId, String token) async {
    await http.patch(
      Uri.parse("${Api.workerBookings}/$bookingId/accept"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );
  }

  Future<void> reject(int bookingId, String token) async {
    await http.patch(
      Uri.parse("${Api.workerBookings}/$bookingId/reject"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );
  }
}