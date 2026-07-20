import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import '../../models/category_model.dart';
import '../../models/worker_service_model.dart';
import '../../providers/category_provider.dart';
import '../../providers/worker_service_provider.dart';

class EditServiceScreen extends StatefulWidget {
  final WorkerServiceModel service;

  const EditServiceScreen({
    super.key,
    required this.service,
  });

  @override
  State<EditServiceScreen> createState() => _EditServiceScreenState();
}

class _EditServiceScreenState extends State<EditServiceScreen> {
  final _formKey = GlobalKey<FormState>();

  final storage = const FlutterSecureStorage();

  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;

  CategoryModel? selectedCategory;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: widget.service.title);
    descriptionController =
        TextEditingController(text: widget.service.description);
    priceController = TextEditingController(text: widget.service.price);

    Future.microtask(() {
      final categoryProvider = context.read<CategoryProvider>();
      if (categoryProvider.categories.isEmpty) {
        categoryProvider.loadCategories();
      } else {
        final match = categoryProvider.categories.where(
          (c) => c.id == widget.service.categoryId,
        );
        if (match.isNotEmpty) {
          setState(() {
            selectedCategory = match.first;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    super.dispose();
  }

  Future<void> updateService() async {
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
      await provider.updateService(
        token: token,
        serviceId: widget.service.id,
        categoryId: selectedCategory!.id,
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        price: priceController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Service updated successfully")),
      );

      Navigator.pop(context, true);
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
        title: const Text("Edit Service"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                          Icon(Icons.edit_note),
                          SizedBox(width: 8),
                          Text(
                            "Update Service",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      DropdownButtonFormField<CategoryModel>(
                        value: selectedCategory,
                        decoration: InputDecoration(
                          labelText: "Category",
                          prefixIcon: const Icon(Icons.category),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: categoryProvider.categories.map((cat) {
                          return DropdownMenuItem(
                            value: cat,
                            child: Text(cat.name),
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
                          prefixIcon: const Icon(Icons.home_repair_service),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (v) =>
                            v!.isEmpty ? "Enter title" : null,
                      ),

                      const SizedBox(height: 20),

                      TextFormField(
                        controller: descriptionController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          labelText: "Description",
                          alignLabelWithHint: true,
                          prefixIcon: const Icon(Icons.description),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (v) =>
                            v!.isEmpty ? "Enter description" : null,
                      ),

                      const SizedBox(height: 20),

                      TextFormField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Price (₹)",
                          prefixIcon: const Icon(Icons.currency_rupee),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (v) =>
                            v!.isEmpty ? "Enter price" : null,
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
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.save),
                  label: Text(
                    workerProvider.loading ? "Updating..." : "Update Service",
                  ),
                  onPressed:
                      workerProvider.loading ? null : updateService,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
