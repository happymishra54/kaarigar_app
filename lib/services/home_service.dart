import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api.dart';
import '../models/category_model.dart';
import '../models/service_model.dart';
import '../models/top_worker_model.dart';

class HomeService {
  Future<List<CategoryModel>> getCategories() async {
    final response = await http.get(
      Uri.parse(Api.categories),
      headers: {
        'Accept': 'application/json',
      },
    );

    final data = jsonDecode(response.body);

    return (data['categories'] as List)
        .map((e) => CategoryModel.fromJson(e))
        .toList();
  }

  Future<List<ServiceModel>> getServices() async {
    final response = await http.get(
      Uri.parse(Api.services),
      headers: {
        'Accept': 'application/json',
      },
    );

    final data = jsonDecode(response.body);

    return (data['services'] as List)
        .map((e) => ServiceModel.fromJson(e))
        .toList();
  }

  Future<List<TopWorkerModel>> getTopWorkers() async {
    final response = await http.get(
      Uri.parse(Api.topWorkers),
      headers: {
        'Accept': 'application/json',
      },
    );

    final data = jsonDecode(response.body);

    return (data['workers'] as List)
        .map((e) => TopWorkerModel.fromJson(e))
        .toList();
  }
}
