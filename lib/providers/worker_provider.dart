import 'package:flutter/material.dart';

import '../models/booking_model.dart';
import '../models/worker_dashboard_model.dart';
import '../services/worker_service.dart';

class WorkerProvider extends ChangeNotifier {
  final WorkerService _service = WorkerService();

  bool loading = false;

  WorkerDashboardModel? stats;

  List<BookingModel> bookings = [];

  Future<void> load(String token) async {
    loading = true;
    notifyListeners();

    try {
      stats = await _service.dashboard(token);

      bookings = await _service.bookings(token);
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> acceptBooking(
    String token,
    int bookingId,
) async {

  await _service.accept(
    bookingId,
    token,
  );

  await load(token);

}

Future<void> rejectBooking(
    String token,
    int bookingId,
) async {

  await _service.reject(
    bookingId,
    token,
  );

  await load(token);

}
}