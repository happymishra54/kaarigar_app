import 'dart:io';

import 'package:flutter/material.dart';

import '../services/add_worker_service.dart';

class AddWorkerProvider extends ChangeNotifier {
  final AddWorkerService _service =
      AddWorkerService();

  bool loading = false;

  Future<void> createWorker({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String bio,
    required String experience,
    required String dailyWage,
    required String city,
    required String state,
    required String address,
    required String aadhaarNumber,
    File? profileImage,
    File? aadhaarImage,
  }) async {

    loading = true;
    notifyListeners();

    try {

      await _service.createWorker(
        name: name,
        email: email,
        password: password,
        phone: phone,
        bio: bio,
        experience: experience,
        dailyWage: dailyWage,
        city: city,
        state: state,
        address: address,
        aadhaarNumber: aadhaarNumber,
        profileImage: profileImage,
        aadhaarImage: aadhaarImage,
      );

    } finally {

      loading = false;
      notifyListeners();

    }
  }
}