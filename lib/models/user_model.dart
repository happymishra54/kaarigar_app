class UserModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String? city;
  final String? profileImage;
  final String role;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.city,
    this.profileImage,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? '',
      city: json['city'],
      profileImage: json['profile_image'],
    );
  }
}