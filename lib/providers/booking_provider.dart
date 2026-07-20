import 'package:flutter/material.dart';

import '../models/booking_model.dart';
import '../services/booking_service.dart';

class BookingProvider extends ChangeNotifier {
  final BookingService _service = BookingService();

  bool loading = false;

  List<BookingModel> bookings = [];

  Future<void> loadBookings(String token) async {
    loading = true;
    notifyListeners();

    try {
      bookings = await _service.getBookings(token);
    } catch (e) {
      rethrow;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<bool> createBooking({
    required String token,
    required int serviceId,
    required String bookingDate,
    required String bookingTime,
    required String address,
  }) async {
    loading = true;
    notifyListeners();

    try {
      final success = await _service.createBooking(
        token: token,
        serviceId: serviceId,
        bookingDate: bookingDate,
        bookingTime: bookingTime,
        address: address,
      );

      return success;
    } catch (e) {
      rethrow;
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}