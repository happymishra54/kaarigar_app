import 'user_model.dart';

class ServiceModel {
  final int id;
  final String title;
  final String slug;
  final String description;
  final double price;
  final String image;
  final String category;
  final UserModel worker;

  ServiceModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
    required this.worker,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'],
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0,
      image: json['image'] ?? '',
      category: json['category'] ?? '',
      worker: UserModel.fromJson(json['worker']),
    );
  }
}