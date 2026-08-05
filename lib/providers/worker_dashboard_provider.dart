import 'package:flutter/material.dart';

import '../services/worker_dashboard_service.dart';


class WorkerDashboardProvider extends ChangeNotifier {


  final WorkerDashboardService _service =
      WorkerDashboardService();


  bool loading = false;

  String? error;

  Map<String,dynamic>? dashboard;


  List bookings = [];



  Future<void> loadDashboard(
    String token,
  ) async {

    loading = true;

    error = null;

    notifyListeners();


    try {

      dashboard =
          await _service.getDashboard(token);

    } catch (e) {

      error = e.toString();

    } finally {

      loading = false;

      notifyListeners();

    }

  }



  Future<void> loadBookings() async {

    loading = true;

    error = null;

    notifyListeners();


    try {

      bookings =
          await _service.getBookings();

    } catch (e) {

      error = e.toString();

    } finally {

      loading = false;

      notifyListeners();

    }

  }



  Future<void> acceptBooking(
      int id,
  ) async {

    await _service.acceptBooking(id);

    notifyListeners();

    await loadBookings();

  }



  Future<void> rejectBooking(
      int id,
  ) async {

    await _service.rejectBooking(id);

    notifyListeners();

    await loadBookings();

  }



  Future<void> completeBooking(
      int id,
  ) async {

    await _service.completeBooking(id);

    notifyListeners();

    await loadBookings();

  }


}