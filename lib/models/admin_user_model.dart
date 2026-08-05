class AdminUser {
  final int id;
  final String name;
  final String? email;
  final String phone;
  final String role;
  final int status;

  AdminUser({
    required this.id,
    required this.name,
    this.email,
    required this.phone,
    required this.role,
    required this.status,
  });

  factory AdminUser.fromJson(Map<String, dynamic> json) {
    return AdminUser(
      id: json["id"],
      name: json["name"] ?? "",
      email: json["email"],
      phone: json["phone"] ?? "",
      role: json["role"] ?? "",
      status: json["status"] ?? 0,
    );
  }
}