class AdminVerifyWorker {
  final int id;
  final String name;
  final String phone;
  final String bio;
  final String city;
  final String state;
  final String experience;
  final String dailyWage;
  final String aadhaarNumber;
  final String aadhaarImage;
  final String profileImage;

  AdminVerifyWorker({
    required this.id,
    required this.name,
    required this.phone,
    required this.bio,
    required this.city,
    required this.state,
    required this.experience,
    required this.dailyWage,
    required this.aadhaarNumber,
    required this.aadhaarImage,
    required this.profileImage,
  });

  factory AdminVerifyWorker.fromJson(Map<String, dynamic> json) {
    final profile = json["worker_profile"] ?? {};

    return AdminVerifyWorker(
      id: json["id"],
      name: json["name"] ?? "",
      phone: json["phone"] ?? "",

      bio: profile["bio"] ?? "",

      city: profile["city"] ?? "",

      state: profile["state"] ?? "",

      experience:
          profile["experience"]?.toString() ?? "",

      dailyWage:
          profile["daily_wage"]?.toString() ?? "",

      aadhaarNumber:
          profile["aadhaar_number"] ?? "",

      aadhaarImage:
          profile["aadhaar_image"] ?? "",

      profileImage:
          profile["profile_image"] ?? "",
    );
  }
}