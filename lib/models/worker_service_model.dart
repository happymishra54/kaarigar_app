class WorkerServiceModel {
  final int id;
  final int categoryId;
  final String title;
  final String description;
  final String price;
  final String image;
  final String status;

  WorkerServiceModel({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.description,
    required this.price,
    required this.image,
    required this.status,
  });

  factory WorkerServiceModel.fromJson(
      Map<String, dynamic> json) {
    return WorkerServiceModel(
      id: json["id"],
      categoryId: json["category_id"],
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      price: json["price"].toString(),
      image: json["image"] ?? "",
      status: json["status"]?.toString() ?? "",
    );
  }
}