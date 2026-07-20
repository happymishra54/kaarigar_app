import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../config/api.dart';
import '../models/worker_service_model.dart';

class WorkerServiceService {

  Future<List<WorkerServiceModel>> getServices(
      String token,
  ) async {

    final response = await http.get(

      Uri.parse(Api.workerServices),

      headers: {

        "Accept": "application/json",

        "Authorization": "Bearer $token",

      },

    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {

      return (data["services"] as List)
          .map((e) => WorkerServiceModel.fromJson(e))
          .toList();

    }

    throw Exception(
      data["message"] ?? "Unable to load services",
    );

  }

  Future<bool> addService({
  required String token,
  required int categoryId,
  required String title,
  required String description,
  required String price,
  File? image,
}) async {

  var request = http.MultipartRequest(
    'POST',
    Uri.parse(Api.workerServices),
  );

  request.headers.addAll({
    "Accept": "application/json",
    "Authorization": "Bearer $token",
  });

  request.fields.addAll({
    "category_id": categoryId.toString(),
    "title": title,
    "description": description,
    "price": price,
  });

  if (image != null) {
    request.files.add(
      await http.MultipartFile.fromPath(
        "image",
        image.path,
      ),
    );
  }

  final response = await request.send();
  final body = await response.stream.bytesToString();
  final data = jsonDecode(body);

  if (response.statusCode == 201) {
    return true;
  }

  throw Exception(
    data["message"] ?? "Unable to add service",
  );
}

Future<bool> updateService({
  required String token,
  required int serviceId,
  required int categoryId,
  required String title,
  required String description,
  required String price,
}) async {

  final response = await http.put(
    Uri.parse("${Api.workerServices}/$serviceId"),
    headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    },
    body: {
      "category_id": categoryId.toString(),
      "title": title,
      "description": description,
      "price": price,
    },
  );

  if (response.statusCode == 200) {
    return true;
  }

  final data = jsonDecode(response.body);
  throw Exception(data["message"] ?? "Unable to update service");
}

Future<bool> deleteService({
  required String token,
  required int serviceId,
}) async {
  final response = await http.delete(
    Uri.parse("${Api.workerServices}/$serviceId"),
    headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    },
  );

  if (response.statusCode == 200) {
    return true;
  }

  final data = jsonDecode(response.body);

  throw Exception(
    data["message"] ?? "Unable to delete service",
  );
}

}