class AdminCategory {
  final int id;
  final String name;
  final String description;
  final String icon;
  final int status;

  AdminCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.status,
  });

  factory AdminCategory.fromJson(Map<String, dynamic> json) {
    return AdminCategory(
      id: json["id"],
      name: json["name"] ?? "",
      description: json["description"] ?? "",
      icon: json["icon"] ?? "",
      status: json["status"] ?? 0,
    );
  }
}