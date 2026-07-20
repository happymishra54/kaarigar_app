import 'package:flutter/material.dart';

import '../models/category_model.dart';
import '../models/service_model.dart';
import '../services/home_service.dart';

class HomeProvider extends ChangeNotifier {
  final HomeService _service = HomeService();

  List<CategoryModel> categories = [];

  List<ServiceModel> services = [];

  bool loading = true;

  Future<void> loadHome() async {
    loading = true;

    notifyListeners();

    categories = await _service.getCategories();

    services = await _service.getServices();

    loading = false;

    notifyListeners();
  }
}