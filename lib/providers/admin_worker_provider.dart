import 'package:flutter/material.dart';

import '../models/admin_verify_worker_model.dart';
import '../models/admin_worker_model.dart';
import '../services/admin_worker_service.dart';

class AdminWorkerProvider extends ChangeNotifier {
  final AdminWorkerService _service = AdminWorkerService();

  bool loading = false;

  List<AdminWorker> workers = [];

  bool pendingLoading = false;

  List<AdminVerifyWorker> pendingWorkers = [];

Future<void> loadWorkers() async {
    loading = true;
    notifyListeners();

    try {
      workers = await _service.getWorkers();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> loadPendingWorkers() async {
    pendingLoading = true;
    notifyListeners();

    try {
      pendingWorkers = await _service.getPendingWorkers();
    } finally {
      pendingLoading = false;
      notifyListeners();
    }
  }

  Future<void> verifyWorker(int id) async {
    await _service.verifyWorker(id);
    await loadPendingWorkers();
    await loadWorkers();
  }

  Future<void> deleteWorker(int id) async {
    await _service.deleteWorker(id);
    await loadWorkers();
  }

  Future<void> toggleStatus(int id) async {
    await _service.toggleStatus(id);
    await loadWorkers();
  }

  Future<void> updateWorker({
    required int id,
    required String name,
    required String email,
    required String phone,
    required String city,
    required String experience,
    required String dailyWage,
  }) async {
    await _service.updateWorker(
      id: id,
      name: name,
      email: email,
      phone: phone,
      city: city,
      experience: experience,
      dailyWage: dailyWage,
    );

    await loadWorkers();
  }

  Future<String> generatePassword(int id) async {
    return await _service.generatePassword(id);
  }
}
