import 'package:flutter/material.dart';

import '../models/category_model.dart';
import '../models/service_model.dart';
import '../models/top_worker_model.dart';
import '../services/home_service.dart';

class HomeProvider extends ChangeNotifier {
  final HomeService _service = HomeService();

  List<CategoryModel> categories = [];

  List<ServiceModel> services = [];

  List<TopWorkerModel> topWorkers = [];

  bool loading = true;

  String? error;

  Future<void> loadHome() async {
    loading = true;
    error = null;

    notifyListeners();

    try {
      categories = await _service.getCategories();

      services = await _service.getServices();

      try {
        topWorkers = await _service.getTopWorkers();
      } catch (_) {
        topWorkers = [];
      }
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;

      notifyListeners();
    }
  }
}
