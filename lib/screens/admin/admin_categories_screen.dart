import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/admin_category_model.dart';
import '../../providers/admin_category_provider.dart';

class AdminCategoriesScreen extends StatefulWidget {
  const AdminCategoriesScreen({super.key});

  @override
  State<AdminCategoriesScreen> createState() =>
      _AdminCategoriesScreenState();
}

class _AdminCategoriesScreenState
    extends State<AdminCategoriesScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context
          .read<AdminCategoryProvider>()
          .loadCategories();
    });
  }

  void _showAddCategoryDialog() {

    final nameController =
        TextEditingController();

    final descriptionController =
        TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {

        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom:
                MediaQuery.of(context)
                        .viewInsets
                        .bottom +
                    20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,
              children: [

                const Text(
                  "Add Category",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                TextField(
                  controller:
                      nameController,
                  decoration:
                      const InputDecoration(
                    labelText:
                        "Category Name",
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller:
                      descriptionController,
                  maxLines: 3,
                  decoration:
                      const InputDecoration(
                    labelText:
                        "Description",
                  ),
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width:
                      double.infinity,
                  child:
                      ElevatedButton(
                    child: const Text(
                        "Add Category"),
                    onPressed:
                        () async {

                      await context
                          .read<
                              AdminCategoryProvider>()
                          .addCategory(
                            name:
                                nameController
                                    .text,
                            description:
                                descriptionController
                                    .text,
                          );

                      if (!mounted) {
                        return;
                      }

                      Navigator.pop(
                          context);

                      ScaffoldMessenger.of(
                              context)
                          .showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Category Added Successfully",
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEditCategoryDialog(
      AdminCategory category) {

    final nameController =
        TextEditingController(
      text: category.name,
    );

    final descriptionController =
        TextEditingController(
      text: category.description,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {

        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom:
                MediaQuery.of(context)
                        .viewInsets
                        .bottom +
                    20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,
              children: [

                const Text(
                  "Edit Category",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                TextField(
                  controller:
                      nameController,
                  decoration:
                      const InputDecoration(
                    labelText:
                        "Category Name",
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller:
                      descriptionController,
                  maxLines: 3,
                  decoration:
                      const InputDecoration(
                    labelText:
                        "Description",
                  ),
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width:
                      double.infinity,
                  child:
                      ElevatedButton(
                    child: const Text(
                        "Save Changes"),
                    onPressed:
                        () async {

                      await context
                          .read<
                              AdminCategoryProvider>()
                          .updateCategory(
                            id:
                                category.id,
                            name:
                                nameController
                                    .text,
                            description:
                                descriptionController
                                    .text,
                          );

                      if (!mounted) {
                        return;
                      }

                      Navigator.pop(
                          context);

                      ScaffoldMessenger.of(
                              context)
                          .showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Category Updated Successfully",
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider =
        context.watch<AdminCategoryProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Categories"),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _showAddCategoryDialog,
        child: const Icon(Icons.add),
      ),

      body: provider.loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () =>
                  provider.loadCategories(),
              child: ListView.builder(
                itemCount:
                    provider.categories.length,
                itemBuilder: (_, index) {

                  final category =
                      provider.categories[index];

                  return Card(
                    elevation: 3,
                    margin:
                        const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [

                          Row(
                            children: [

                              CircleAvatar(
                                radius: 25,
                                backgroundColor:
                                    Colors.blue.shade100,
                                child: const Icon(
                                  Icons.category,
                                  color: Colors.blue,
                                ),
                              ),

                              const SizedBox(
                                  width: 15),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                  children: [

                                    Text(
                                      category.name,
                                      style:
                                          const TextStyle(
                                        fontWeight:
                                            FontWeight
                                                .bold,
                                        fontSize: 18,
                                      ),
                                    ),

                                    const SizedBox(
                                        height: 4),

                                    Text(
                                      category
                                              .description
                                              .isEmpty
                                          ? "No description"
                                          : category
                                              .description,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const Divider(
                            height: 25,
                          ),

                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.end,
                            children: [

                              /// EDIT
                              Tooltip(
                                message:
                                    "Edit Category",
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () {
                                    _showEditCategoryDialog(
                                        category);
                                  },
                                ),
                              ),

                              /// STATUS
                              Tooltip(
                                message:
                                    category.status == 1
                                        ? "Deactivate"
                                        : "Activate",
                                child: IconButton(
                                  icon: Icon(
                                    category.status ==
                                            1
                                        ? Icons.toggle_on
                                        : Icons.toggle_off,
                                    color: category
                                                .status ==
                                            1
                                        ? Colors.green
                                        : Colors.grey,
                                    size: 36,
                                  ),
                                  onPressed:
                                      () async {

                                    await provider
                                        .toggleStatus(
                                            category
                                                .id);

                                    if (!mounted) {
                                      return;
                                    }

                                    ScaffoldMessenger.of(
                                            context)
                                        .showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Status Updated",
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),

                              /// DELETE
                              Tooltip(
                                message:
                                    "Delete Category",
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed:
                                      () async {

                                    final confirm =
                                        await showDialog<
                                            bool>(
                                      context:
                                          context,
                                      builder:
                                          (_) =>
                                              AlertDialog(
                                        title:
                                            const Text(
                                          "Delete Category",
                                        ),
                                        content:
                                            Text(
                                          "Delete ${category.name} permanently?",
                                        ),
                                        actions: [

                                          TextButton(
                                            onPressed:
                                                () {
                                              Navigator.pop(
                                                  context,
                                                  false);
                                            },
                                            child:
                                                const Text(
                                              "Cancel",
                                            ),
                                          ),

                                          ElevatedButton(
                                            style:
                                                ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.red,
                                              foregroundColor:
                                                  Colors.white,
                                            ),
                                            onPressed:
                                                () {
                                              Navigator.pop(
                                                  context,
                                                  true);
                                            },
                                            child:
                                                const Text(
                                              "Delete",
                                            ),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (confirm ==
                                        true) {

                                      await provider
                                          .deleteCategory(
                                              category
                                                  .id);

                                      if (!mounted) {
                                        return;
                                      }

                                      ScaffoldMessenger.of(
                                              context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Category Deleted",
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
