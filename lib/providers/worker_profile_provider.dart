import 'dart:io';

import 'package:flutter/material.dart';

import '../services/worker_profile_service.dart';

class WorkerProfileProvider extends ChangeNotifier {
  final WorkerProfileService _service = WorkerProfileService();

  bool loading = false;

  File? profileImage;

  File? aadhaarImage;

  Future<bool> completeProfile({
    required String city,
    required String bio,
    required String experience,
    required String aadhaarNumber,
    required String address,
    required String dailyWage,
    File? profileImage,
    File? aadhaarImage,
  }) async {
    loading = true;

    notifyListeners();

    try {
      final success = await _service.completeProfile(
        city: city,
        bio: bio,
        experience: experience,
        aadhaarNumber: aadhaarNumber,
        address: address,
        dailyWage: dailyWage,
        profileImage: profileImage,
        aadhaarImage: aadhaarImage,
      );

      loading = false;

      notifyListeners();

      return success;
    } catch (e) {
      loading = false;

      notifyListeners();

      rethrow;
    }
  }
}