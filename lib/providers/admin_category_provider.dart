import 'package:flutter/material.dart';

import '../models/admin_category_model.dart';
import '../services/admin_category_service.dart';

class AdminCategoryProvider extends ChangeNotifier {
  final AdminCategoryService _service = AdminCategoryService();

  bool loading = false;

  List<AdminCategory> categories = [];

  Future<void> loadCategories() async {
    loading = true;
    notifyListeners();

    try {
      categories = await _service.getCategories();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> addCategory({
    required String name,
    required String description,
  }) async {
    await _service.addCategory(
      name: name,
      description: description,
    );

    await loadCategories();
  }

  Future<void> updateCategory({
    required int id,
    required String name,
    required String description,
  }) async {
    await _service.updateCategory(
      id: id,
      name: name,
      description: description,
    );

    await loadCategories();
  }

  Future<void> deleteCategory(int id) async {
    await _service.deleteCategory(id);

    await loadCategories();
  }

  Future<void> toggleStatus(int id) async {
    await _service.toggleStatus(id);

    await loadCategories();
  }
}