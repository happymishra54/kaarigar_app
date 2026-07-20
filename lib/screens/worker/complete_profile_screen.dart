import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../config/api.dart';
import '../../providers/worker_profile_provider.dart';
import 'worker_bottom_nav.dart';


class CompleteProfileScreen extends StatefulWidget {

  final Map<String, dynamic>? profile;

  const CompleteProfileScreen({
    super.key,
    this.profile,
  });


  @override
  State<CompleteProfileScreen> createState() =>
      _CompleteProfileScreenState();
}


class _CompleteProfileScreenState
    extends State<CompleteProfileScreen> {


  final _formKey = GlobalKey<FormState>();


  late final TextEditingController cityController;
  late final TextEditingController addressController;
  late final TextEditingController experienceController;
  late final TextEditingController bioController;
  late final TextEditingController aadhaarController;
  late final TextEditingController wageController;


  File? profileImage;

  File? aadhaarImage;



  final ImagePicker picker = ImagePicker();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<String?> _getToken() async {
    return await _storage.read(key: "token");
  }

  @override
  void initState() {
    super.initState();

    // Pre-fill form fields with existing profile data if available
    final p = widget.profile;
    cityController = TextEditingController(text: p?['city']?.toString() ?? '');
    addressController = TextEditingController(text: p?['address']?.toString() ?? '');
    experienceController = TextEditingController(text: p?['experience']?.toString() ?? '');
    bioController = TextEditingController(text: p?['bio']?.toString() ?? '');
    aadhaarController = TextEditingController(text: p?['aadhaar_number']?.toString() ?? '');
    wageController = TextEditingController(text: p?['daily_wage']?.toString() ?? '');
  }



  @override
  void dispose() {

    cityController.dispose();

    addressController.dispose();

    experienceController.dispose();

    bioController.dispose();

    aadhaarController.dispose();

    wageController.dispose();

    super.dispose();

  }



  Future<void> pickProfileImage() async {

    final image = await picker.pickImage(
      source: ImageSource.gallery,
    );


    if(image != null){

      setState(() {

        profileImage = File(image.path);

      });

    }

  }



  Future<void> pickAadhaarImage() async {

    final image = await picker.pickImage(
      source: ImageSource.gallery,
    );


    if(image != null){

      setState(() {

        aadhaarImage = File(image.path);

      });

    }

  }



  Future<void> saveProfile() async {


    if(!_formKey.currentState!.validate()){

      return;

    }


    final provider =
        context.read<WorkerProfileProvider>();


    try {


      final success =
          await provider.completeProfile(

        city: cityController.text.trim(),

        bio: bioController.text.trim(),

        experience:
            experienceController.text.trim(),

        aadhaarNumber:
            aadhaarController.text.trim(),

        address:
            addressController.text.trim(),

        dailyWage:
            wageController.text.trim(),

        profileImage: profileImage,

        aadhaarImage: aadhaarImage,

      );



      if(!mounted) return;



      if(success){

        // Fetch the updated profile to pass to dashboard
        Map<String, dynamic>? profileData;

        try {
          final token = await _getToken();
          if (token != null) {
            final response = await http.get(
              Uri.parse(Api.workerProfileStatus),
              headers: {
                "Accept": "application/json",
                "Authorization": "Bearer $token",
              },
            );
            if (response.statusCode == 200) {
              final data = jsonDecode(response.body);
              profileData = data['profile'];
            }
          }
        } catch (_) {
          // Silently fail - dashboard will load from API anyway
        }

        if (!mounted) return;

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => WorkerBottomNav(
              profile: profileData,
            ),
          ),
          (route) => false,
        );

      }


    } catch(e){


      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(

          content:
              Text(e.toString()),

        ),

      );


    }


  }



  @override
  Widget build(BuildContext context) {


    final provider =
        context.watch<WorkerProfileProvider>();


    return Scaffold(

      appBar: AppBar(

        title:
            const Text(
              "Complete Profile",
            ),

      ),


      body:
          SafeArea(

            child:
                SingleChildScrollView(

                  padding:
                      const EdgeInsets.all(24),

                  child:
                      Form(

                        key: _formKey,

                        child:
                            Column(

                              children: [

                                                                GestureDetector(
                                  onTap: pickProfileImage,
                                  child: CircleAvatar(
                                    radius: 55,
                                    backgroundImage:
                                        profileImage != null
                                            ? FileImage(profileImage!)
                                            : null,
                                    child: profileImage == null
                                        ? const Icon(
                                            Icons.camera_alt,
                                            size: 40,
                                          )
                                        : null,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                const Text(
                                  "Upload Profile Photo",
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),

                                const SizedBox(height: 30),


                                GestureDetector(
                                  onTap: pickAadhaarImage,
                                  child: Container(
                                    height: 140,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    child: aadhaarImage == null
                                        ? const Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [

                                              Icon(
                                                Icons.credit_card,
                                                size: 45,
                                              ),

                                              SizedBox(height: 8),

                                              Text(
                                                "Upload Aadhaar Image",
                                              ),

                                            ],
                                          )
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: Image.file(
                                              aadhaarImage!,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                  ),
                                ),


                                const SizedBox(height: 30),



                                TextFormField(
                                  controller: cityController,
                                  decoration: const InputDecoration(
                                    labelText: "City",
                                    prefixIcon:
                                        Icon(Icons.location_city),
                                    border:
                                        OutlineInputBorder(),
                                  ),
                                  validator: (value){

                                    if(value == null ||
                                        value.isEmpty){

                                      return "Enter city";

                                    }

                                    return null;

                                  },
                                ),


                                const SizedBox(height: 20),



                                TextFormField(
                                  controller: addressController,
                                  maxLines: 2,
                                  decoration: const InputDecoration(
                                    labelText: "Address",
                                    prefixIcon:
                                        Icon(Icons.home),
                                    border:
                                        OutlineInputBorder(),
                                  ),
                                  validator: (value){

                                    if(value == null ||
                                        value.isEmpty){

                                      return "Enter address";

                                    }

                                    return null;

                                  },
                                ),


                                const SizedBox(height: 20),



                                TextFormField(
                                  controller:
                                      experienceController,
                                  keyboardType:
                                      TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText:
                                        "Experience (Years)",
                                    prefixIcon:
                                        Icon(Icons.work),
                                    border:
                                        OutlineInputBorder(),
                                  ),
                                  validator: (value){

                                    if(value == null ||
                                        value.isEmpty){

                                      return "Enter experience";

                                    }

                                    return null;

                                  },
                                ),


                                const SizedBox(height: 20),
                                                                TextFormField(
                                  controller: bioController,
                                  maxLines: 4,
                                  decoration: const InputDecoration(
                                    labelText: "About Yourself",
                                    prefixIcon: Icon(
                                      Icons.description,
                                    ),
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty) {
                                      return "Enter your bio";
                                    }

                                    return null;
                                  },
                                ),


                                const SizedBox(height: 20),



                                TextFormField(
                                  controller: aadhaarController,
                                  keyboardType:
                                      TextInputType.number,
                                  maxLength: 12,
                                  decoration: const InputDecoration(
                                    labelText:
                                        "Aadhaar Number",
                                    prefixIcon:
                                        Icon(Icons.badge),
                                    border:
                                        OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty) {
                                      return "Enter Aadhaar number";
                                    }

                                    if (value.length != 12) {
                                      return "Aadhaar must be 12 digits";
                                    }

                                    return null;
                                  },
                                ),



                                const SizedBox(height: 20),



                                TextFormField(
                                  controller: wageController,
                                  keyboardType:
                                      TextInputType.number,
                                  decoration:
                                      const InputDecoration(
                                    labelText:
                                        "Daily Wage",
                                    prefixIcon:
                                        Icon(Icons.currency_rupee),
                                    border:
                                        OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty) {
                                      return "Enter daily wage";
                                    }

                                    return null;
                                  },
                                ),



                                const SizedBox(height: 30),



                                SizedBox(
                                  width: double.infinity,
                                  height: 55,
                                  child: ElevatedButton(
                                    onPressed:
                                        provider.loading
                                            ? null
                                            : saveProfile,

                                    child:
                                        provider.loading
                                            ? const SizedBox(
                                                height: 25,
                                                width: 25,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                ),
                                              )
                                            : const Text(
                                                "SAVE PROFILE",
                                                style:
                                                    TextStyle(
                                                  fontSize: 17,
                                                ),
                                              ),
                                  ),
                                ),


                              ],
                            ),
                          ),
                        ),
                      ),
                );
  }
}
