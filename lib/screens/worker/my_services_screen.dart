import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'add_service_screen.dart';
import '../../providers/worker_service_provider.dart';
import 'edit_service_screen.dart';

class MyServicesScreen extends StatefulWidget {
  const MyServicesScreen({super.key});

  @override
  State<MyServicesScreen> createState() => _MyServicesScreenState();
}

class _MyServicesScreenState extends State<MyServicesScreen> {
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    loadServices();
  }

  Future<void> loadServices() async {
    final token = await storage.read(key: "token");

    if (token != null) {
      await context.read<WorkerServiceProvider>().loadServices(token);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WorkerServiceProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Services"),
      ),
      body: RefreshIndicator(
        onRefresh: loadServices,
        child: provider.loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : provider.services.isEmpty
                ? const Center(
                    child: Text("No services found"),
                  )
                : ListView.builder(
                    itemCount: provider.services.length,
                    itemBuilder: (context, index) {
                      final service = provider.services[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 8,
                        ),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              service.image,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) {
                                return const Icon(
                                  Icons.home_repair_service,
                                  size: 40,
                                );
                              },
                            ),
                          ),
                          title: Text(service.title),
                          subtitle: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text("₹${service.price}"),
                              Text(service.status),
                            ],
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == "edit") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EditServiceScreen(
                                      service: service,
                                    ),
                                  ),
                                ).then((_) {
                                  loadServices();
                                });
                              } else if (value == "delete") {
                                showDialog(
                                  context: context,
                                  builder: (_) {
                                    return AlertDialog(
                                      title: const Text("Delete Service"),
                                      content: const Text(
                                        "Are you sure you want to delete this service?",
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Cancel"),
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            Navigator.pop(context);

                                            final token =
                                                await storage.read(key: "token");

                                            if (token == null) return;

                                            await provider.deleteService(
                                              token: token,
                                              serviceId: service.id,
                                            );

                                            loadServices();
                                          },
                                          child: const Text("Delete"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            itemBuilder: (_) => const [
                              PopupMenuItem(
                                value: "edit",
                                child: Text("Edit"),
                              ),
                              PopupMenuItem(
                                value: "delete",
                                child: Text("Delete"),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
      floatingActionButton: FloatingActionButton(
  onPressed: () async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddServiceScreen(),
      ),
    );

    loadServices();
  },
  child: const Icon(Icons.add),
),
    );
  }
}