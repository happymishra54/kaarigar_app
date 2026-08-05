import 'package:flutter/material.dart';

import '../models/booking_model.dart';
import '../services/booking_service.dart';

class BookingProvider extends ChangeNotifier {
  final BookingService _service = BookingService();

  bool loading = false;

  String? error;

  List<BookingModel> bookings = [];

  Future<void> loadBookings() async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      bookings = await _service.getBookings();
    } catch (e) {
      error = e.toString();
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
    error = null;
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
      error = e.toString();
      rethrow;
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
