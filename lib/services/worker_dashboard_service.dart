import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../config/api.dart';


class WorkerDashboardService {


  final FlutterSecureStorage storage =
      const FlutterSecureStorage();



  Future<String> getToken() async {

    final token =
        await storage.read(
          key: "token",
        );

    if(token == null){

      throw Exception(
        "Token missing",
      );

    }

    return token;

  }



  Future<Map<String, dynamic>> getDashboard(String token) async {

  final response = await http.get(
    Uri.parse(Api.workerDashboard),
    headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    },
  );

final data = jsonDecode(response.body);

  if (response.statusCode == 200) {
    return data;
  }

  throw Exception(
    data["message"] ?? "Unable to load dashboard",
  );
}





  Future<List> getBookings() async {


    final token =
        await getToken();


    final response =
        await http.get(

      Uri.parse(
        Api.workerBookings,
      ),

      headers: {

        "Accept":
            "application/json",

        "Authorization":
            "Bearer $token",

      },

    );



    final data =
        jsonDecode(response.body);



    if(response.statusCode == 200){

      return data["bookings"];

    }


    throw Exception(

      data["message"] ??
          "Unable to load bookings",

    );


  }





  Future<void> acceptBooking(
      int id,
  ) async {


    await updateBookingStatus(
      id,
      "accept",
    );

  }





  Future<void> rejectBooking(
      int id,
  ) async {


    await updateBookingStatus(
      id,
      "reject",
    );

  }





  Future<void> completeBooking(
      int id,
  ) async {


    await updateBookingStatus(
      id,
      "complete",
    );

  }






  Future<void> updateBookingStatus(
      int id,
      String action,
  ) async {


    final token =
        await getToken();



    final response =
        await http.patch(

      Uri.parse(
        "${Api.workerBookings}/$id/$action",
      ),

      headers: {

        "Accept":
            "application/json",

        "Authorization":
            "Bearer $token",

      },

    );



    if(response.statusCode != 200){

      final data =
          jsonDecode(response.body);


      throw Exception(

        data["message"] ??
            "Action failed",

      );

    }


  }


}