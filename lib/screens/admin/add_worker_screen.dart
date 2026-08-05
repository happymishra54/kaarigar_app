import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddWorkerScreen extends StatefulWidget {
  const AddWorkerScreen({super.key});

  @override
  State<AddWorkerScreen> createState() =>
      _AddWorkerScreenState();
}

class _AddWorkerScreenState
    extends State<AddWorkerScreen> {

  final _formKey = GlobalKey<FormState>();

  final nameController =
      TextEditingController();

  final emailController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  final phoneController =
      TextEditingController();

  final experienceController =
      TextEditingController();

  final dailyWageController =
      TextEditingController();

  final bioController =
      TextEditingController();

  final cityController =
      TextEditingController();

  final stateController =
      TextEditingController();

  final addressController =
      TextEditingController();

  final aadhaarController =
      TextEditingController();

  File? profileImage;

  File? aadhaarImage;

  final ImagePicker picker =
      ImagePicker();

  bool loading = false;

  Future<void> pickProfileImage() async {

    final picked =
        await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );

    if (picked == null) return;

    setState(() {
      profileImage = File(picked.path);
    });
  }

  Future<void> pickAadhaarImage() async {

    final picked =
        await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );

    if (picked == null) return;

    setState(() {
      aadhaarImage = File(picked.path);
    });
  }

  @override
  void dispose() {

    nameController.dispose();

    emailController.dispose();

    passwordController.dispose();

    phoneController.dispose();

    experienceController.dispose();

    dailyWageController.dispose();

    bioController.dispose();

    cityController.dispose();

    stateController.dispose();

    addressController.dispose();

    aadhaarController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Worker"),
      ),

      body: Form(
        key: _formKey,

        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              /// PERSONAL DETAILS
              Card(
                elevation: 3,

                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(15),
                ),

                child: Padding(
                  padding:
                      const EdgeInsets.all(16),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [

                      const Text(
                        "Personal Details",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      TextFormField(
                        controller:
                            nameController,

                        decoration:
                            const InputDecoration(
                          labelText: "Full Name",
                          border:
                              OutlineInputBorder(),
                        ),

                        validator: (value) {
                          if (value == null ||
                              value.isEmpty) {
                            return "Enter name";
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 15),

                      TextFormField(
                        controller:
                            emailController,

                        decoration:
                            const InputDecoration(
                          labelText:
                              "Email (Optional)",
                          border:
                              OutlineInputBorder(),
                        ),

                        keyboardType:
                            TextInputType
                                .emailAddress,
                      ),

                      const SizedBox(height: 15),

                      TextFormField(
                        controller:
                            passwordController,

                        decoration:
                            const InputDecoration(
                          labelText: "Password",
                          border:
                              OutlineInputBorder(),
                        ),

                        obscureText: true,

                        validator: (value) {
                          if (value == null ||
                              value.isEmpty) {
                            return "Enter password";
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 15),

                      TextFormField(
                        controller:
                            phoneController,

                        decoration:
                            const InputDecoration(
                          labelText:
                              "Phone Number",
                          border:
                              OutlineInputBorder(),
                        ),

                        keyboardType:
                            TextInputType.phone,

                        validator: (value) {
                          if (value == null ||
                              value.length != 10) {
                            return "Enter valid phone";
                          }

                          return null;
                        },
                      ),

                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// PROFESSIONAL DETAILS

              Card(
                elevation: 3,

                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(15),
                ),

                child: Padding(
                  padding:
                      const EdgeInsets.all(16),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [

                      const Text(
                        "Professional Details",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      TextFormField(
                        controller:
                            bioController,

                        decoration:
                            const InputDecoration(
                          labelText:
                              "Profession / Bio",
                          border:
                              OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 15),

                      TextFormField(
                        controller:
                            experienceController,

                        decoration:
                            const InputDecoration(
                          labelText:
                              "Experience (Years)",
                          border:
                              OutlineInputBorder(),
                        ),

                        keyboardType:
                            TextInputType.number,
                      ),

                      const SizedBox(height: 15),

                      TextFormField(
                        controller:
                            dailyWageController,

                        decoration:
                            const InputDecoration(
                          labelText:
                              "Daily Wage",
                          border:
                              OutlineInputBorder(),
                        ),

                        keyboardType:
                            TextInputType.number,
                      ),

                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
                            /// ADDRESS DETAILS

              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      const Text(
                        "Address Details",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      TextFormField(
                        controller: cityController,
                        decoration: const InputDecoration(
                          labelText: "City",
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 15),

                      TextFormField(
                        controller: stateController,
                        decoration: const InputDecoration(
                          labelText: "State",
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 15),

                      TextFormField(
                        controller: addressController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: "Address",
                          border: OutlineInputBorder(),
                        ),
                      ),

                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// VERIFICATION

              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      const Text(
                        "Verification",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      TextFormField(
                        controller: aadhaarController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Aadhaar Number",
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        "Profile Image",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 10),

                      GestureDetector(
                        onTap: pickProfileImage,
                        child: Container(
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                            ),
                            borderRadius:
                                BorderRadius.circular(12),
                          ),
                          child: profileImage == null
                              ? const Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.person,
                                      size: 45,
                                    ),
                                    SizedBox(height: 10),
                                    Text("Tap to upload"),
                                  ],
                                )
                              : ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(12),
                                  child: Image.file(
                                    profileImage!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        "Aadhaar Image",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 10),

                      GestureDetector(
                        onTap: pickAadhaarImage,
                        child: Container(
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                            ),
                            borderRadius:
                                BorderRadius.circular(12),
                          ),
                          child: aadhaarImage == null
                              ? const Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.badge,
                                      size: 45,
                                    ),
                                    SizedBox(height: 10),
                                    Text("Tap to upload"),
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
                                            Row(
                        children: [

                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {

                                Navigator.pop(context);

                              },

                              child: const Text(
                                "Cancel",
                              ),
                            ),
                          ),

                          const SizedBox(width: 15),

                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {

                                if (!_formKey.currentState!
                                    .validate()) {
                                  return;
                                }

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "API integration coming next...",
                                    ),
                                  ),
                                );

                              },

                              child: const Text(
                                "Create Worker",
                              ),
                            ),
                          ),

                        ],
                      ),

                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

            ],
          ),
        ),
      ),
    );
  }
}
