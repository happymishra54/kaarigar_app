import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../config/api.dart';


class WorkerProfileService {

  final FlutterSecureStorage storage =
      const FlutterSecureStorage();



  Future<bool> completeProfile({

    required String city,

    required String bio,

    required String experience,

    required String aadhaarNumber,

    required String address,

    required String dailyWage,

    File? profileImage,

    File? aadhaarImage,

  }) async {


    final token =
        await storage.read(
          key: "token",
        );


    if(token == null){

      throw Exception(
        "Token missing. Login again."
      );

    }



    var request =
        http.MultipartRequest(
          'POST',
          Uri.parse(
            Api.completeProfile,
          ),
        );



    request.headers.addAll({

      "Accept":"application/json",

      "Authorization":
          "Bearer $token",

    });



    request.fields.addAll({

      "city":city,

      "bio":bio,

      "experience":experience,

      "aadhaar_number":aadhaarNumber,

      "address":address,

      "daily_wage":dailyWage,

    });



    if(profileImage != null){

      request.files.add(
        await http.MultipartFile.fromPath(

          "profile_image",

          profileImage.path,

        ),
      );

    }



    if(aadhaarImage != null){

      request.files.add(
        await http.MultipartFile.fromPath(

          "aadhaar_image",

          aadhaarImage.path,

        ),
      );

    }



    final response =
        await request.send();



    final body =
        await response.stream.bytesToString();



    print("PROFILE RESPONSE:");
    print(response.statusCode);
    print(body);



    final data =
        jsonDecode(body);



    if(response.statusCode == 200){

      return true;

    }



    throw Exception(
      data["message"] ??
      "Profile completion failed"
    );

  }

  Future<Map<String,dynamic>> checkProfileStatus() async {

  final token = await storage.read(
    key: "token",
  );


  if (token == null) {

    throw Exception(
      "Token missing. Login again."
    );

  }


  final response = await http.get(

    Uri.parse(
      Api.workerProfileStatus,
    ),

    headers: {

      "Accept": "application/json",

      "Authorization":
          "Bearer $token",

    },

  );


  final data = jsonDecode(
    response.body,
  );


  print("PROFILE STATUS RESPONSE:");
  print(response.statusCode);
  print(data);



  if(response.statusCode == 200){

    return data;

  }


  throw Exception(
    data["message"] ??
    "Unable to check profile status"
  );

}

}