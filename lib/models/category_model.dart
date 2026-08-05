class CategoryModel {
  final int id;
  final String name;
  final String icon;

  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {

    String icon = json["icon"] ?? "";

    // Android Emulator cannot access 127.0.0.1
    icon = icon.replaceAll(
      "127.0.0.1",
      "10.0.2.2",
    );

    return CategoryModel(
      id: json["id"],
      name: json["name"] ?? "",
      icon: icon,
    );
  }
}