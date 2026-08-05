class AdminWorker {
  final int id;
  final String name;
  final String phone;
  final int status;
  final String email;
  final String city;
  final String experience;
  final String dailyWage;
  final bool verified;

  AdminWorker({
    required this.id,
    required this.name,
    required this.phone,
    required this.status,
    required this.email,
    required this.city,
    required this.experience,
    required this.dailyWage,
    required this.verified,
  });

  factory AdminWorker.fromJson(Map<String, dynamic> json) {
    final profile = json["worker_profile"] ?? {};

    return AdminWorker(
      id: json["id"],
      name: json["name"] ?? "",
      phone: json["phone"] ?? "",
      status: json["status"],
      email: json["email"] ?? "",
      city: profile["city"] ?? "",
      experience: profile["experience"]?.toString() ?? "",
      dailyWage: profile["daily_wage"]?.toString() ?? "0",
      verified: profile["is_verified"] == 1 ||
          profile["is_verified"] == true,
    );
  }
}