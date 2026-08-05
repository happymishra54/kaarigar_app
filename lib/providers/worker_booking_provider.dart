import 'package:flutter/material.dart';

import '../models/worker_booking_model.dart';
import '../services/worker_booking_service.dart';

/// Provider that manages the worker's bookings and their lifecycle
/// (accept, reject, complete).
class WorkerBookingProvider extends ChangeNotifier {
  final WorkerBookingService _service = WorkerBookingService();

  bool loading = false;
  String? error;

  List<WorkerBookingModel> bookings = [];

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

  Future<void> acceptBooking(int id) async {
    await _operation(() => _service.acceptBooking(id));
  }

  Future<void> rejectBooking(int id) async {
    await _operation(() => _service.rejectBooking(id));
  }

  Future<void> completeBooking(int id) async {
    await _operation(() => _service.completeBooking(id));
  }

  Future<void> _operation(Future<void> Function() action) async {
    try {
      await action();
      await loadBookings();
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
  }
}
