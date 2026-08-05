import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../config/api.dart';
import '../../models/nearby_worker_model.dart';

class NearbyWorkersScreen extends StatefulWidget {
  const NearbyWorkersScreen({super.key});

  @override
  State<NearbyWorkersScreen> createState() => _NearbyWorkersScreenState();
}

class _NearbyWorkersScreenState extends State<NearbyWorkersScreen> {
  final storage = const FlutterSecureStorage();

  List<NearbyWorkerModel> workers = [];
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadNearbyWorkers();
  }

  Future<void> loadNearbyWorkers() async {
    setState(() {
      loading = true;
      error = null;
    });

    try {
      final token = await storage.read(key: "token");

      if (token == null) {
        throw Exception("Not logged in");
      }

      final response = await http.get(
        Uri.parse(Api.nearbyWorkers),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final List raw = data["workers"] ?? data["data"] ?? [];

        workers = raw
            .map((e) => NearbyWorkerModel.fromJson(e))
            .toList();
      } else {
        throw Exception(
          data["message"] ?? "Unable to load nearby workers",
        );
      }
    } catch (e) {
      error = e.toString();
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  Future<void> _callWorker(String phone) async {
    final telUri = Uri(scheme: 'tel', path: phone);

    final canLaunch = await canLaunchUrl(telUri);

    if (!canLaunch) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Unable to place the call"),
        ),
      );
      return;
    }

    await launchUrl(telUri);
  }

  String _formatDistance(double km) {
    if (km <= 0) return "";
    if (km < 1) return "${(km * 1000).round()} m away";
    return "${km.toStringAsFixed(1)} km away";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nearby Workers"),
      ),
      body: RefreshIndicator(
        onRefresh: loadNearbyWorkers,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.cloud_off,
                size: 80,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                "Couldn't load nearby workers",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade500),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: loadNearbyWorkers,
                icon: const Icon(Icons.refresh),
                label: const Text("Retry"),
              ),
            ],
          ),
        ),
      );
    }

    if (workers.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_off,
                size: 80,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                "No nearby workers found",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Workers near you will appear here.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade500),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: workers.length,
      itemBuilder: (_, index) {
        final worker = workers[index];
        return _workerCard(worker);
      },
    );
  }

  Widget _workerCard(NearbyWorkerModel worker) {
    final distance = _formatDistance(worker.distance);

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: const Color(0xff2563EB),
              child: worker.profileImage.isEmpty
                  ? const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 34,
                    )
                  : ClipOval(
                      child: Image.network(
                        worker.profileImage,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 34,
                        ),
                      ),
                    ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          worker.name.isEmpty ? "Unknown" : worker.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      if (worker.verified) ...[
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.verified,
                          color: Colors.blue,
                          size: 18,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    worker.profession,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (worker.city.isNotEmpty) ...[
                        const Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 3),
                        Flexible(
                          child: Text(
                            worker.city,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                      if (distance.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Text(
                          distance,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (worker.dailyWage.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      "₹${worker.dailyWage}/day",
                      style: const TextStyle(
                        color: Color(0xff2563EB),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 10),
            if (worker.phone.isNotEmpty)
              IconButton.filled(
                tooltip: "Call",
                style: IconButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => _callWorker(worker.phone),
                icon: const Icon(Icons.call),
              ),
          ],
        ),
      ),
    );
  }
}
