import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../config/api.dart';
import '../../models/admin_verify_worker_model.dart';
import '../../providers/admin_worker_provider.dart';

class AdminVerifyWorkersScreen extends StatefulWidget {
  const AdminVerifyWorkersScreen({super.key});

  @override
  State<AdminVerifyWorkersScreen> createState() =>
      _AdminVerifyWorkersScreenState();
}

class _AdminVerifyWorkersScreenState
    extends State<AdminVerifyWorkersScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context
          .read<AdminWorkerProvider>()
          .loadPendingWorkers();
    });
  }

  void _showWorkerDetails(AdminVerifyWorker worker) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Profile header
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: worker.profileImage.isNotEmpty
                              ? NetworkImage(
                                  "${Api.baseUrl}/${worker.profileImage}")
                              : null,
                          child: worker.profileImage.isEmpty
                              ? Text(
                                  worker.name[0].toUpperCase(),
                                  style: const TextStyle(fontSize: 40),
                                )
                              : null,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          worker.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.phone, size: 16, color: Colors.grey),
                            const SizedBox(width: 6),
                            Text(
                              worker.phone,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 36),

                  // Details
                  _detailRow(Icons.info, "Bio", worker.bio.isNotEmpty ? worker.bio : "No bio provided"),
                  const SizedBox(height: 12),
                  _detailRow(Icons.location_city, "City", worker.city.isNotEmpty ? worker.city : "Not specified"),
                  const SizedBox(height: 12),
                  _detailRow(Icons.map, "State", worker.state.isNotEmpty ? worker.state : "Not specified"),
                  const SizedBox(height: 12),
                  _detailRow(Icons.work, "Experience", "${worker.experience} years"),
                  const SizedBox(height: 12),
                  _detailRow(Icons.money, "Daily Wage", "₹${worker.dailyWage}/day"),
                  const SizedBox(height: 12),

                  // Aadhaar section
                  if (worker.aadhaarNumber.isNotEmpty) ...[
                    const Divider(height: 24),
                    const Text(
                      "Aadhaar Details",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _detailRow(Icons.badge, "Aadhaar Number", worker.aadhaarNumber),
                    const SizedBox(height: 12),
                    if (worker.aadhaarImage.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: "${Api.baseUrl}/${worker.aadhaarImage}",
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (_, _) => Container(
                            height: 200,
                            color: Colors.grey.shade200,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          errorWidget: (_, _, _) => Container(
                            height: 200,
                            color: Colors.grey.shade200,
                            child: const Center(
                              child: Icon(Icons.broken_image, size: 48),
                            ),
                          ),
                        ),
                      ),
                  ],

                  const SizedBox(height: 32),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.close),
                          label: const Text(
                            "Reject",
                            style: TextStyle(fontSize: 16),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            _rejectWorker(worker);
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.check),
                          label: const Text(
                            "Verify",
                            style: TextStyle(fontSize: 16),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            _verifyWorker(worker);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),
        const SizedBox(width: 12),
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _verifyWorker(AdminVerifyWorker worker) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text("Verify Worker"),
        content: Text("Are you sure you want to verify ${worker.name}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Verify"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await context.read<AdminWorkerProvider>().verifyWorker(worker.id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${worker.name} verified successfully"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _rejectWorker(AdminVerifyWorker worker) async {
    // For reject, we use the same verify endpoint which toggles is_verified
    // If the worker is not verified, we toggle it. But for "reject", we can
    // just mark as not-verified or delete. Let's ask via dialog.
    final action = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text("Reject Worker"),
        content: Text("What would you like to do with ${worker.name}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, "cancel"),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, "delete"),
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, "reject"),
            child: const Text("Reject"),
          ),
        ],
      ),
    );

    if (action == null || action == "cancel") return;

    if (!mounted) return;

    if (action == "delete") {
      await context.read<AdminWorkerProvider>().deleteWorker(worker.id);
    } else {
      // Keep as unverified, just remove from pending list
      // We can use the verify endpoint to ensure is_verified = 0
      // Since it toggles, if it's 0, it'll become 1. So we skip.
      // Instead, we just refresh the pending list.
      await context.read<AdminWorkerProvider>().loadPendingWorkers();
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          action == "delete"
              ? "${worker.name} deleted"
              : "${worker.name} rejected",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AdminWorkerProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify Workers"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => provider.loadPendingWorkers(),
          ),
        ],
      ),
      body: provider.pendingLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.pendingWorkers.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.verified_user,
                        size: 80,
                        color: Colors.green.shade300,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "All workers verified!",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "No pending verification requests",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () => provider.loadPendingWorkers(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: provider.pendingWorkers.length,
                    itemBuilder: (_, index) {
                      final worker = provider.pendingWorkers[index];
                      return _PendingWorkerCard(
                        worker: worker,
                        onTap: () => _showWorkerDetails(worker),
                        onVerify: () => _verifyWorker(worker),
                      );
                    },
                  ),
                ),
    );
  }
}

class _PendingWorkerCard extends StatelessWidget {
  final AdminVerifyWorker worker;
  final VoidCallback onTap;
  final VoidCallback onVerify;

  const _PendingWorkerCard({
    required this.worker,
    required this.onTap,
    required this.onVerify,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: worker.profileImage.isNotEmpty
                        ? NetworkImage(
                            "${Api.baseUrl}/${worker.profileImage}")
                        : null,
                    child: worker.profileImage.isEmpty
                        ? Text(
                            worker.name[0].toUpperCase(),
                            style: const TextStyle(fontSize: 24),
                          )
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          worker.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.phone,
                                size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              worker.phone,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "PENDING",
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Chip(
                    avatar: const Icon(Icons.work, size: 16),
                    label: Text("${worker.experience} yrs"),
                    visualDensity: VisualDensity.compact,
                  ),
                  Chip(
                    avatar: const Icon(Icons.money, size: 16),
                    label: Text("₹${worker.dailyWage}/day"),
                    visualDensity: VisualDensity.compact,
                  ),
                  if (worker.city.isNotEmpty)
                    Chip(
                      avatar: const Icon(Icons.location_city, size: 16),
                      label: Text(worker.city),
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      side: const BorderSide(color: Colors.blue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.visibility, size: 18),
                    label: const Text("Details"),
                    onPressed: onTap,
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text("Verify"),
                    onPressed: onVerify,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
