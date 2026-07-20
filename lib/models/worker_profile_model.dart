class WorkerProfileModel {

  final String? profileImage;
  final String? aadhaarImage;
  final String? bio;
  final int? experience;
  final int? dailyWage;
  final String? address;
  final String? city;


  WorkerProfileModel({

    this.profileImage,

    this.aadhaarImage,

    this.bio,

    this.experience,

    this.dailyWage,

    this.address,

    this.city,

  });



  factory WorkerProfileModel.fromJson(
      Map<String,dynamic> json
  ){

    return WorkerProfileModel(

      profileImage: json['profile_image'],

      aadhaarImage: json['aadhaar_image'],

      bio: json['bio'],

      experience: json['experience'],

      dailyWage: json['daily_wage'],

      address: json['address'],

      city: json['city'],

    );

  }

}