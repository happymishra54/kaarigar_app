import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api.dart';
import '../models/booking_model.dart';

class BookingService {
  Future<bool> createBooking({
    required String token,
    required int serviceId,
    required String bookingDate,
    required String bookingTime,
    required String address,
  }) async {
    final response = await http.post(
      Uri.parse(Api.booking),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
      body: {
        "service_id": serviceId.toString(),
        "booking_date": bookingDate,
        "booking_time": bookingTime,
        "address": address,
      },
    );

    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      return true;
    }

    throw Exception(jsonDecode(response.body)["message"]);
  }

  Future<List<BookingModel>> getBookings(
      String token) async {

    final response = await http.get(
      Uri.parse(Api.myBookings),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    final data = jsonDecode(response.body);

    return (data["bookings"] as List)
        .map((e) => BookingModel.fromJson(e))
        .toList();
  }
}