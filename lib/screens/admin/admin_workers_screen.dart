import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/admin_worker_provider.dart';
import '../../models/admin_worker_model.dart';
import 'package:flutter/services.dart';

class AdminWorkersScreen extends StatefulWidget {
  const AdminWorkersScreen({super.key});

  @override
  State<AdminWorkersScreen> createState() =>
      _AdminWorkersScreenState();
}

class _AdminWorkersScreenState
    extends State<AdminWorkersScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<AdminWorkerProvider>().loadWorkers();
    });
  }

  void _showEditWorkerDialog(AdminWorker worker) {

  final nameController =
      TextEditingController(text: worker.name);

  final emailController =
      TextEditingController(text: worker.email);

  final phoneController =
      TextEditingController(text: worker.phone);

  final cityController =
      TextEditingController(text: worker.city);

  final experienceController =
      TextEditingController(
        text: worker.experience,
      );

  final wageController =
      TextEditingController(
        text: worker.dailyWage,
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
              MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              const Text(
                "Edit Worker",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: "Phone",
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: cityController,
                decoration: const InputDecoration(
                  labelText: "City",
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: experienceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Experience",
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: wageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Daily Wage",
                ),
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  child: const Text("Save Changes"),
                  onPressed: () async {

                    await context
                        .read<AdminWorkerProvider>()
                        .updateWorker(
                          id: worker.id,
                          name: nameController.text,
                          email: emailController.text,
                          phone: phoneController.text,
                          city: cityController.text,
                          experience:
                              experienceController.text,
                          dailyWage:
                              wageController.text,
                        );

                    if (!mounted) return;

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Worker Updated Successfully",
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
        context.watch<AdminWorkerProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Workers"),
      ),

      body: provider.loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () =>
                  provider.loadWorkers(),
              child: ListView.builder(
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 20,
                ),
                itemCount: provider.workers.length,
                itemBuilder: (_, index) {

                  final AdminWorker worker =
                      provider.workers[index];

                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(16),
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
                                radius: 28,
                                backgroundColor:
                                    Colors.blue.shade100,
                                child: Text(
                                  worker.name[0]
                                      .toUpperCase(),
                                  style:
                                      const TextStyle(
                                    fontSize: 22,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ),

                              const SizedBox(width: 15),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,

                                  children: [

                                    Text(
                                      worker.name,
                                      style:
                                          const TextStyle(
                                        fontSize: 18,
                                        fontWeight:
                                            FontWeight
                                                .bold,
                                      ),
                                    ),

                                    const SizedBox(
                                        height: 5),

                                    Text(
                                      worker.phone,
                                    ),

                                    const SizedBox(
                                        height: 8),

                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: [

                                        Chip(
                                          label: Text(
                                            worker.city,
                                          ),
                                        ),

                                        Chip(
                                          backgroundColor:
                                              Colors
                                                  .green
                                                  .shade100,
                                          label: Text(
                                            "${worker.experience} Years",
                                          ),
                                        ),

                                        Chip(
                                          backgroundColor:
                                              Colors.orange
                                                  .shade100,
                                          label: Text(
                                            "₹${worker.dailyWage}/day",
                                          ),
                                        ),

                                        Chip(
                                          backgroundColor:
                                              worker.verified
                                                  ? Colors
                                                      .green
                                                      .shade100
                                                  : Colors
                                                      .red
                                                      .shade100,

                                          label: Text(
                                            worker.verified
                                                ? "Verified"
                                                : "Not Verified",
                                          ),
                                        ),

                                      ],
                                    ),

                                  ],
                                ),
                              ),

                            ],
                          ),

                          const Divider(
                            height: 28,
                          ),

                                                    Row(
                            mainAxisAlignment:
                                MainAxisAlignment.end,
                            children: [

                              // Generate password

                              Tooltip(
  message: "Generate Password",
  child: IconButton(
    icon: const Icon(
      Icons.key,
      color: Colors.orange,
    ),
    onPressed: () async {
      try {
        final password = await context
            .read<AdminWorkerProvider>()
            .generatePassword(worker.id);

        if (!mounted) return;

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: const [
                Icon(
                  Icons.key,
                  color: Colors.orange,
                ),
                SizedBox(width: 10),
                Text("Password Generated"),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  worker.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 15),

                const Text(
                  "Give this password to the worker:",
                ),

                const SizedBox(height: 12),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  child: SelectableText(
                    password,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              OutlinedButton.icon(
                icon: const Icon(Icons.copy),
                label: const Text("Copy"),
                onPressed: () async {
                  await Clipboard.setData(
                    ClipboardData(text: password),
                  );

                  if (!mounted) return;

                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Password copied successfully",
                      ),
                    ),
                  );
                },
              ),

              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Close"),
              ),
            ],
          ),
        );
      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
    },
  ),
),

                              // Edit
                              Tooltip(
                                message: "Edit Worker",
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () {
                                    _showEditWorkerDialog(worker);
                                  },
                                ),
                              ),

                              // Verify / Unverify
                              Tooltip(
                                message: worker.verified
                                    ? "Unverify Worker"
                                    : "Verify Worker",
                                child: IconButton(
                                  icon: Icon(
                                    worker.verified
                                        ? Icons.verified
                                        : Icons.verified_outlined,
                                    color: worker.verified
                                        ? Colors.green
                                        : Colors.orange,
                                  ),
                                  onPressed: () async {

                                    await provider
                                        .verifyWorker(
                                            worker.id);

                                    if (context.mounted) {
                                      ScaffoldMessenger.of(
                                              context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            worker.verified
                                                ? "Worker Unverified"
                                                : "Worker Verified",
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),

                              // Active / Inactive
                              Tooltip(
                                message: worker.status == 1
                                    ? "Deactivate Worker"
                                    : "Activate Worker",
                                child: IconButton(
                                  icon: Icon(
                                    worker.status == 1
                                        ? Icons.toggle_on
                                        : Icons.toggle_off,
                                    size: 38,
                                    color: worker.status == 1
                                        ? Colors.green
                                        : Colors.grey,
                                  ),
                                  onPressed: () async {

  await provider.toggleStatus(worker.id);

  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          worker.status == 1
              ? "Worker Deactivated"
              : "Worker Activated",
        ),
      ),
    );
  }

},
                                ),
                              ),

                              // Delete
                              Tooltip(
                                message: "Delete Worker",
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () async {

                                    final confirm =
                                        await showDialog<bool>(
                                      context: context,
                                      builder: (_) =>
                                          AlertDialog(
                                        title: const Text(
                                            "Delete Worker"),
                                        content: Text(
                                          "Delete ${worker.name} permanently?",
                                        ),
                                        actions: [

                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(
                                                  context,
                                                  false);
                                            },
                                            child: const Text(
                                                "Cancel"),
                                          ),

                                          ElevatedButton(
                                            style:
                                                ElevatedButton
                                                    .styleFrom(
                                              backgroundColor:
                                                  Colors.red,
                                              foregroundColor:
                                                  Colors.white,
                                            ),
                                            onPressed: () {
                                              Navigator.pop(
                                                  context,
                                                  true);
                                            },
                                            child: const Text(
                                                "Delete"),
                                          ),

                                        ],
                                      ),
                                    );

                                    if (confirm == true) {

                                      await provider
                                          .deleteWorker(
                                              worker.id);

                                      if (context.mounted) {
                                        ScaffoldMessenger.of(
                                                context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "Worker Deleted",
                                            ),
                                          ),
                                        );
                                      }
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