class TopWorkerModel {
  final int id;
  final String name;
  final String phone;
  final String profession;
  final String city;
  final String experience;
  final String dailyWage;
  final String profileImage;
  final double rating;
  final int reviewsCount;
  final bool verified;

  TopWorkerModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.profession,
    required this.city,
    required this.experience,
    required this.dailyWage,
    required this.profileImage,
    required this.rating,
    required this.reviewsCount,
    required this.verified,
  });

  factory TopWorkerModel.fromJson(Map<String, dynamic> json) {
    final profile = json["worker_profile"] ?? {};

    return TopWorkerModel(
      id: json["id"] ?? 0,
      name: json["name"]?.toString() ?? "",
      phone: json["phone"]?.toString() ?? "",
      profession: profile["profession"]?.toString() ??
          json["profession"]?.toString() ??
          "Professional",
      city: profile["city"]?.toString() ?? json["city"]?.toString() ?? "",
      experience: profile["experience"]?.toString() ??
          json["experience"]?.toString() ??
          "",
      dailyWage: profile["daily_wage"]?.toString() ??
          json["daily_wage"]?.toString() ??
          "",
      profileImage: profile["profile_image"]?.toString() ??
          json["profile_image"]?.toString() ??
          "",
      rating: double.tryParse(
            (json["reviews_avg_rating"] ?? 0).toString(),
          ) ??
          0,
      reviewsCount: json["reviews_count"] ?? 0,
      verified: profile["is_verified"] == 1 ||
          profile["is_verified"] == true ||
          json["is_verified"] == 1 ||
          json["is_verified"] == true,
    );
  }
}
