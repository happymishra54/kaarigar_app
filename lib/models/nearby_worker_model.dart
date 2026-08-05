class NearbyWorkerModel {
  final int id;
  final String name;
  final String phone;
  final String profession;
  final String city;
  final String state;
  final String experience;
  final String dailyWage;
  final String address;
  final String bio;
  final String profileImage;
  final double rating;
  final double distance;
  final bool verified;

  NearbyWorkerModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.profession,
    required this.city,
    required this.state,
    required this.experience,
    required this.dailyWage,
    required this.address,
    required this.bio,
    required this.profileImage,
    required this.rating,
    required this.distance,
    required this.verified,
  });

  factory NearbyWorkerModel.fromJson(Map<String, dynamic> json) {
    final profile = json["worker_profile"] ?? {};

    // Handle both nested profile and flat structures.
    final name = json["name"]?.toString() ?? "";
    final phone = json["phone"]?.toString() ?? "";
    final profileImage = profile["profile_image"]?.toString() ??
        json["profile_image"]?.toString() ??
        "";

    return NearbyWorkerModel(
      id: json["id"] ?? 0,
      name: name,
      phone: phone,
      // Profession may be derived from the user's profession field or a
      // service/category title. Fall back to a sensible default.
      profession: profile["profession"]?.toString() ??
          json["profession"]?.toString() ??
          "Professional",
      city: profile["city"]?.toString() ?? json["city"]?.toString() ?? "",
      state: profile["state"]?.toString() ?? json["state"]?.toString() ?? "",
      experience: profile["experience"]?.toString() ??
          json["experience"]?.toString() ??
          "",
      dailyWage: profile["daily_wage"]?.toString() ??
          json["daily_wage"]?.toString() ??
          "",
      address: profile["address"]?.toString() ?? json["address"]?.toString() ?? "",
      bio: profile["bio"]?.toString() ?? json["bio"]?.toString() ?? "",
      profileImage: profileImage,
      rating: double.tryParse(
            (json["rating"] ?? profile["rating"] ?? 0).toString(),
          ) ??
          0,
      distance: double.tryParse(
            (json["distance"] ?? json["distance_km"] ?? 0).toString(),
          ) ??
          0,
      verified: json["is_verified"] == 1 ||
          json["is_verified"] == true ||
          profile["is_verified"] == 1 ||
          profile["is_verified"] == true,
    );
  }
}
