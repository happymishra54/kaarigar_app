class FavoriteWorkerModel {
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
  final bool verified;

  const FavoriteWorkerModel({
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
    required this.verified,
  });

  factory FavoriteWorkerModel.fromJson(Map<String, dynamic> json) {
    final worker = json['worker'] ?? json;
    final profile = worker['workerProfile'] ?? worker['worker_profile'] ?? {};

    return FavoriteWorkerModel(
      id: worker['id'] ?? 0,
      name: worker['name']?.toString() ?? '',
      phone: worker['phone']?.toString() ?? '',
      profession: profile['profession']?.toString() ??
          worker['profession']?.toString() ??
          'Professional',
      city: profile['city']?.toString() ??
          worker['city']?.toString() ??
          '',
      state: profile['state']?.toString() ??
          worker['state']?.toString() ??
          '',
      experience: profile['experience']?.toString() ??
          worker['experience']?.toString() ??
          '',
      dailyWage: profile['daily_wage']?.toString() ??
          worker['daily_wage']?.toString() ??
          '',
      address: profile['address']?.toString() ??
          worker['address']?.toString() ??
          '',
      bio: profile['bio']?.toString() ??
          worker['bio']?.toString() ??
          '',
      profileImage: profile['profile_image']?.toString() ??
          worker['profile_image']?.toString() ??
          '',
      rating: double.tryParse(
            (worker['rating'] ?? profile['rating'] ?? 0).toString(),
          ) ??
          0,
      verified: worker['is_verified'] == 1 ||
          worker['is_verified'] == true ||
          profile['is_verified'] == 1 ||
          profile['is_verified'] == true,
    );
  }
}
