import 'package:flutter/material.dart';

import '../models/admin_booking_model.dart';
import '../services/admin_booking_service.dart';

class AdminBookingProvider extends ChangeNotifier {
  final AdminBookingService _service = AdminBookingService();

  bool loading = false;

  List<AdminBooking> bookings = [];

  Future<void> loadBookings() async {
    loading = true;
    notifyListeners();

    try {
      bookings = await _service.getBookings();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> updateStatus({
    required int id,
    required String status,
  }) async {
    await _service.updateStatus(
      id: id,
      status: status,
    );

    await loadBookings();
  }

  Future<void> deleteBooking(int id) async {
    await _service.deleteBooking(id);

    await loadBookings();
  }
}