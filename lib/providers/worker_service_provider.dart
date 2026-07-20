import 'dart:io';

import 'package:flutter/material.dart';

import '../models/worker_service_model.dart';
import '../services/worker_service_service.dart';

class WorkerServiceProvider extends ChangeNotifier {

  final WorkerServiceService _service =
      WorkerServiceService();

  bool loading = false;

  List<WorkerServiceModel> services = [];

  Future<void> loadServices(
      String token,
  ) async {

    loading = true;

    notifyListeners();

    try {

      services =
          await _service.getServices(token);

    } finally {

      loading = false;

      notifyListeners();

    }

  }

  Future<bool> addService({
  required String token,
  required int categoryId,
  required String title,
  required String description,
  required String price,
  File? image,
}) async {

  loading = true;
  notifyListeners();

  try {

    final success = await _service.addService(
      token: token,
      categoryId: categoryId,
      title: title,
      description: description,
      price: price,
      image: image,
    );

    if (success) {
      await loadServices(token);
    }

    return success;

  } finally {

    loading = false;
    notifyListeners();

  }
}

Future<bool> updateService({
  required String token,
  required int serviceId,
  required int categoryId,
  required String title,
  required String description,
  required String price,
}) async {

  loading = true;
  notifyListeners();

  try {

    final success = await _service.updateService(
      token: token,
      serviceId: serviceId,
      categoryId: categoryId,
      title: title,
      description: description,
      price: price,
    );

    if (success) {
      await loadServices(token);
    }

    return success;

  } finally {

    loading = false;
    notifyListeners();

  }
}

Future<bool> deleteService({
  required String token,
  required int serviceId,
}) async {
  loading = true;
  notifyListeners();

  try {
    final success = await _service.deleteService(
      token: token,
      serviceId: serviceId,
    );

    if (success) {
      await loadServices(token);
    }

    return success;
  } finally {
    loading = false;
    notifyListeners();
  }
}

}