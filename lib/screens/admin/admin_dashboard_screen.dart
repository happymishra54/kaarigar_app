import 'package:flutter/material.dart';

import '../../services/admin_dashboard_service.dart';
import 'admin_users_screen.dart';
import 'admin_workers_screen.dart';
import 'admin_categories_screen.dart';
import 'admin_verify_workers_screen.dart';
import 'package:kaarigar_app/screens/admin/admin_bookings_screen.dart';
import 'add_worker_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final AdminDashboardService _dashboardService = AdminDashboardService();

  bool loading = true;
  String? error;
  Map<String, dynamic> stats = {};

  @override
  void initState() {
    super.initState();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    try {
      setState(() {
        loading = true;
        error = null;
      });

final result = await _dashboardService.getDashboard();
      setState(() {
        stats = result;
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
        error = e.toString();
      });
      debugPrint("AdminDashboard Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text("Admin Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: loadDashboard,
          ),
        ],
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          error!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: loadDashboard,
                          icon: const Icon(Icons.refresh),
                          label: const Text("Retry"),
                        ),
                      ],
                    ),
                  ),
                )
              : SafeArea(
              child: RefreshIndicator(
                onRefresh: loadDashboard,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.blue,
                              child: Icon(
                                Icons.admin_panel_settings,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                            SizedBox(height: 15),
                            Text(
                              "Welcome Admin",
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Manage your Kaarigar platform",
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 35),
                      const Text(
                        "Statistics",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        childAspectRatio: 1.0,
                        children: [
                          DashboardCard(
                            title: "Users",
                            value: "${stats["users"] ?? 0}",
                            color: Colors.blue,
                            icon: Icons.people,
                          ),
                          DashboardCard(
                            title: "Workers",
                            value: "${stats["workers"] ?? 0}",
                            color: Colors.green,
                            icon: Icons.engineering,
                          ),
                          DashboardCard(
                            title: "Customers",
                            value: "${stats["customers"] ?? 0}",
                            color: Colors.orange,
                            icon: Icons.person,
                          ),
                          DashboardCard(
                            title: "Categories",
                            value: "${stats["categories"] ?? 0}",
                            color: Colors.purple,
                            icon: Icons.category,
                          ),
                          
                          DashboardCard(
                            title: "Bookings",
                            value: "${stats["bookings"] ?? 0}",
                            color: Colors.red,
                            icon: Icons.calendar_month,
                          ),
                        ],
                      ),
                      const SizedBox(height: 35),
                      const Text(
                        "Quick Actions",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      ActionButton(
                        icon: Icons.people,
                        title: "Manage Users",
                        color: Colors.blue,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AdminUsersScreen(),
                            ),
                          );
                        },
                      ),
                      ActionButton(
  icon: Icons.engineering,
  title: "Manage Workers",
  color: Colors.indigo,
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AdminWorkersScreen(),
      ),
    );
  },
),
                      ActionButton(
  icon: Icons.category,
  title: "Categories",
  color: Colors.green,
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AdminCategoriesScreen(),
      ),
    );
  },
),
                      
                      ActionButton(
                        icon: Icons.calendar_month,
                        title: "Bookings",
                        color: Colors.red,
                        onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const AdminBookingsScreen(),
    ),
  );
},
                      ),
                      ActionButton(
                        icon: Icons.verified_user,
                        title: "Verify Workers",
                        color: Colors.deepPurple,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AdminVerifyWorkersScreen(),
                            ),
                          );
                        },
                      ),
                      ActionButton(
                        icon: Icons.person_add,
                        title: "Add Worker",
                        color: Colors.blue,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AddWorkerScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 16,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: color.withValues(alpha: .15),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const ActionButton({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SizedBox(
        width: double.infinity,
        height: 58,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            elevation: 2,
            backgroundColor: color,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          onPressed: onTap,
          icon: Icon(
            icon,
            size: 22,
          ),
          label: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
