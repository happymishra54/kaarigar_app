import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../models/category_model.dart';
import '../../providers/category_provider.dart';
import '../../providers/worker_service_provider.dart';

class AddServiceScreen extends StatefulWidget {
  const AddServiceScreen({super.key});

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  final _formKey = GlobalKey<FormState>();

  final storage = const FlutterSecureStorage();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();

  CategoryModel? selectedCategory;

  File? serviceImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<CategoryProvider>().loadCategories();
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        serviceImage = File(image.path);
      });
    }
  }

  Future<void> saveService() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a category")),
      );
      return;
    }

    final token = await storage.read(key: "token");
    if (token == null) return;

    final provider = context.read<WorkerServiceProvider>();

    try {
      await provider.addService(
        token: token,
        categoryId: selectedCategory!.id,
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        price: priceController.text.trim(),
        image: serviceImage,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Service added successfully")),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
Widget build(BuildContext context) {
  final categoryProvider = context.watch<CategoryProvider>();
  final workerProvider = context.watch<WorkerServiceProvider>();

  return Scaffold(
    appBar: AppBar(
      elevation: 0,
      title: const Text(
        "Add Service",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Add a new service for your customers",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 24),

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Row(
                      children: [
                        Icon(Icons.design_services),
                        SizedBox(width: 8),
                        Text(
                          "Service Information",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Service Image
                    GestureDetector(
                      onTap: pickImage,
                      child: Container(
                        height: 160,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1.5,
                            strokeAlign: BorderSide.strokeAlignOutside,
                          ),
                        ),
                        child: serviceImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  serviceImage!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 160,
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.cloud_upload_outlined,
                                    size: 48,
                                    color: Colors.grey.shade400,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Upload Service Image",
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Tap to select",
                                    style: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    DropdownButtonFormField<CategoryModel>(
                      initialValue: selectedCategory,
                      decoration: InputDecoration(
                        labelText: "Category",
                        prefixIcon: const Icon(Icons.category),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                      ),
                      items: categoryProvider.categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value;
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: "Service Title",
                        prefixIcon:
                            const Icon(Icons.home_repair_service),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? "Enter title" : null,
                    ),

                    const SizedBox(height: 20),

                    TextFormField(
                      controller: descriptionController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: "Description",
                        alignLabelWithHint: true,
                        prefixIcon:
                            const Icon(Icons.description),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) =>
                          value!.isEmpty
                              ? "Enter description"
                              : null,
                    ),

                    const SizedBox(height: 20),

                    TextFormField(
                      controller: priceController,
                      keyboardType:
                          TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Price",
                        prefixIcon:
                            const Icon(Icons.currency_rupee),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) =>
                          value!.isEmpty
                              ? "Enter price"
                              : null,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            Card(
              color: Colors.blue.shade50,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(14),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    Icon(
                      Icons.lightbulb,
                      color: Colors.amber,
                    ),

                    SizedBox(width: 12),

                    Expanded(
                      child: Text(
                        "Use a clear title, describe your service well, and set a fair price to attract more customers.",
                        style: TextStyle(height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                icon: workerProvider.loading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.save),

                label: Text(
                  workerProvider.loading
                      ? "Saving..."
                      : "Save Service",
                ),

                onPressed:
                    workerProvider.loading
                        ? null
                        : saveService,
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