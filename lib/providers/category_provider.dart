import 'package:flutter/material.dart';

import '../models/category_model.dart';
import '../services/category_service.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryService _service = CategoryService();

  List<CategoryModel> categories = [];

  bool loading = false;

  Future<void> loadCategories() async {
    loading = true;
    notifyListeners();

    categories = await _service.getCategories();

    loading = false;
    notifyListeners();
  }
}