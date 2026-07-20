import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import '../../providers/worker_dashboard_provider.dart';
import '../profile/profile_screen.dart';
import 'add_service_screen.dart';
import 'my_services_screen.dart';
import 'worker_bookings_screen.dart';

class WorkerDashboardScreen extends StatefulWidget {
  final Map<String, dynamic>? profile;

  const WorkerDashboardScreen({
    super.key,
    this.profile,
  });

  @override
  State<WorkerDashboardScreen> createState() =>
      _WorkerDashboardScreenState();
}

class _WorkerDashboardScreenState
    extends State<WorkerDashboardScreen> {

  final storage = const FlutterSecureStorage();

  String name = "Worker";
  String city = "";
  String state = "";
  String experience = "";
  String profileImage = "";
  String bio = "";
  String address = "";
  String mobile = "";
  String email = "";
  String workerId = "";
  String dailyWage = "";
  String aadhaarNumber = "";
  bool isVerified = false;

  @override
  void initState() {
    super.initState();

    if (widget.profile != null) {
      final worker = widget.profile!;

      name = worker["name"]?.toString() ?? "Worker";
      city = worker["city"]?.toString() ?? "";
      state = worker["state"]?.toString() ?? "";
      experience = worker["experience"]?.toString() ?? "";
      bio = worker["bio"]?.toString() ?? "";
      address = worker["address"]?.toString() ?? "";
      mobile = worker["mobile"]?.toString() ?? "";
      email = worker["email"]?.toString() ?? "";
      workerId = worker["id"]?.toString() ?? "";
      dailyWage = worker["daily_wage"]?.toString() ?? "";
      aadhaarNumber =
          worker["aadhaar_number"]?.toString() ?? "";

      isVerified = worker["is_verified"] == 1;

      final image = worker["profile_image"];

      if (image != null &&
          image.toString().isNotEmpty) {
        profileImage = image.toString().startsWith("http")
            ? image.toString()
            : "http://10.0.2.2:8000/storage/$image";
      }
    }

    loadDashboard();
  }


  Future<void> loadDashboard() async {
  name = await storage.read(key: "name") ?? "Worker";

  final token = await storage.read(key: "token");

  if (token != null) {
    await context
        .read<WorkerDashboardProvider>()
        .loadDashboard(token);
  }

  if (!mounted) return;

  final dashboard =
      context.read<WorkerDashboardProvider>().dashboard;

  if (dashboard != null && dashboard['worker'] != null) {
    final worker = dashboard['worker'];

    name = worker['name']?.toString() ?? name;
    city = worker['city']?.toString() ?? city;
    state = worker['state']?.toString() ?? state;
    experience =worker['experience']?.toString() ?? experience;
    bio = worker['bio']?.toString() ?? bio;
    address = worker['address']?.toString() ?? address;
    mobile = worker['mobile']?.toString() ?? mobile;
    email = worker['email']?.toString() ?? email;
    workerId = worker["id"].toString();
    dailyWage =worker['daily_wage']?.toString() ?? dailyWage;
    aadhaarNumber =worker['aadhaar_number']?.toString() ??aadhaarNumber;
    isVerified = worker['is_verified'] == 1;

    final image = worker['profile_image'];

    if (image != null &&
        image.toString().isNotEmpty) {
      profileImage = image.toString().startsWith("http")
          ? image.toString()
          : "http://10.0.2.2:8000/storage/$image";
    }
  }

  if (mounted) {
    setState(() {});
  }
}

@override
Widget build(BuildContext context) {
  final provider =
      context.watch<WorkerDashboardProvider>();

  final dashboard = provider.dashboard;

  return Scaffold(
    backgroundColor: const Color(0xffF5F7FA),

    appBar: AppBar(
      elevation: 0,
      centerTitle: false,
      title: const Text(
        "Dashboard",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none),
          onPressed: () {},
        ),
        const SizedBox(width: 8),
      ],
    ),

    body: RefreshIndicator(
      onRefresh: loadDashboard,
      child: ListView(
        padding: const EdgeInsets.all(18),
        children: [

          Container(
  padding: const EdgeInsets.all(20),
  decoration: BoxDecoration(
    color: Theme.of(context).colorScheme.primary,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Theme.of(context)
            .colorScheme
            .primary
            .withOpacity(.20),
        blurRadius: 16,
        offset: const Offset(0, 6),
      ),
    ],
  ),
  child: Row(
    children: [
      CircleAvatar(
  radius: 34,
  backgroundColor: Colors.white,
  child: profileImage.isEmpty
      ? Icon(
          Icons.person,
          size: 38,
          color: Theme.of(context).colorScheme.primary,
        )
      : ClipOval(
          child: Image.network(
            profileImage,
            width: 68,
            height: 68,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) {
              return Icon(
                Icons.person,
                size: 38,
                color: Theme.of(context).colorScheme.primary,
              );
            },
          ),
        ),
),

      const SizedBox(width: 18),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              if (isVerified)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Verified Worker",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
               
            const SizedBox(height: 10),

            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: Colors.white70,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    city.isEmpty
                        ? "Location not added"
                        : "$city, $state",
                    style: const TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ),
              ],
            ),

            if (experience.isNotEmpty) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(
                    Icons.work_outline,
                    color: Colors.white70,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "$experience Years Experience",
                    style: const TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    ],
  ),
),

const SizedBox(height: 24),

Container(
  padding: const EdgeInsets.all(20),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(18),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(.08),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Worker Information",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      const SizedBox(height: 18),

      ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.location_city),
        title: const Text("City"),
        subtitle: Text(
          city.isEmpty ? "Not Added" : city,
        ),
      ),

      const Divider(),

      ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.map),
        title: const Text("State"),
        subtitle: Text(
          state.isEmpty ? "Not Added" : state,
        ),
      ),

      const Divider(),

      ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.home),
        title: const Text("Address"),
        subtitle: Text(
          address.isEmpty ? "Not Added" : address,
        ),
      ),
      const Divider(),

ListTile(
  contentPadding: EdgeInsets.zero,
  leading: const Icon(Icons.phone),
  title: const Text("Mobile"),
  subtitle: Text(
    mobile.isEmpty ? "Not Added" : mobile,
  ),
),

const Divider(),

ListTile(
  contentPadding: EdgeInsets.zero,
  leading: const Icon(Icons.email),
  title: const Text("Email"),
  subtitle: Text(
    email.isEmpty ? "Not Added" : email,
  ),
),

const Divider(),

ListTile(
  contentPadding: EdgeInsets.zero,
  leading: const Icon(Icons.badge_outlined),
  title: const Text("Worker ID"),
  subtitle: Text(workerId),
),

      const Divider(),

      ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.description),
        title: const Text("Bio"),
        subtitle: Text(
          bio.isEmpty ? "Not Added" : bio,
        ),
      ),

      const Divider(),

      ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.work),
        title: const Text("Experience"),
        subtitle: Text(
          experience.isEmpty
              ? "Not Added"
              : "$experience Years",
        ),
      ),

      const Divider(),

      ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.currency_rupee),
        title: const Text("Daily Wage"),
        subtitle: Text(
          dailyWage.isEmpty
              ? "Not Added"
              : "₹ $dailyWage / Day",
        ),
      ),

      const Divider(),

      ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.badge),
        title: const Text("Aadhaar Number"),
        subtitle: Text(
          aadhaarNumber.isEmpty
              ? "Not Added"
              : "XXXX XXXX ${aadhaarNumber.length >= 4 ? aadhaarNumber.substring(aadhaarNumber.length - 4) : aadhaarNumber}",
        ),
      ),

      const Divider(),

      ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(
          isVerified
              ? Icons.verified
              : Icons.pending_actions,
          color: isVerified
              ? Colors.green
              : Colors.orange,
        ),
        title: const Text("Verification"),
        subtitle: Text(
          isVerified
              ? "Verified Worker"
              : "Verification Pending",
          style: TextStyle(
            color: isVerified
                ? Colors.green
                : Colors.orange,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ],
  ),
),

const SizedBox(height: 24),

Row(
  children: [

    Expanded(
      child: dashboardCard(
        title: "Services",
        value:
            "${dashboard?['services'] ?? 0}",
        icon:
            Icons.home_repair_service,
      ),
    ),

    const SizedBox(width: 12),

    Expanded(
      child: dashboardCard(
        title: "Bookings",
        value:
            "${dashboard?['total_bookings'] ?? 0}",
        icon:
            Icons.calendar_month,
      ),
    ),

  ],
),

const SizedBox(height: 12),

Row(
  children: [

    Expanded(
      child: dashboardCard(
        title: "Pending",
        value:
            "${dashboard?['pending_bookings'] ?? 0}",
        icon:
            Icons.pending_actions,
      ),
    ),

    const SizedBox(width: 12),

    Expanded(
      child: dashboardCard(
        title: "Earnings",
        value:
            "₹${dashboard?['earnings'] ?? 0}",
        icon:
            Icons.currency_rupee,
      ),
    ),

  ],
),

const SizedBox(height: 25),

const Text(
  "Quick Actions",
  style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 16),

GridView.count(
  physics:
      const NeverScrollableScrollPhysics(),

  shrinkWrap: true,

  crossAxisCount: 2,

  crossAxisSpacing: 14,

  mainAxisSpacing: 14,

  childAspectRatio: 1.15,

  children: [

    _actionCard(
      context,
      Icons.add_circle,
      "Add Service",
      () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                const AddServiceScreen(),
          ),
        );
      },
    ),

    _actionCard(
      context,
      Icons.build,
      "My Services",
      () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const MyServicesScreen(),
          ),
        );
      },
    ),

    _actionCard(
      context,
      Icons.calendar_today,
      "Bookings",
      () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const WorkerBookingsScreen(),
          ),
        );
      },
    ),

    _actionCard(
      context,
      Icons.person,
      "Profile",
      () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ProfileScreen(),
          ),
        );
      },
    ),

  ],
),

const SizedBox(height: 30),

const Text(
  "Recent Bookings",
  style: TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
  ),
),

      if (provider.loading)
  const Padding(
    padding: EdgeInsets.all(30),
    child: Center(
      child: CircularProgressIndicator(),
    ),
  )
else if (
    dashboard?['recent_bookings'] == null ||
    dashboard?['recent_bookings']!.isEmpty
)
  Container(
    padding: const EdgeInsets.all(30),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
    ),
    child: const Column(
      children: [
        Icon(
          Icons.calendar_today_outlined,
          size: 60,
          color: Colors.grey,
        ),
        SizedBox(height: 15),
        Text(
          "No bookings yet",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          "Your recent bookings will appear here.",
          textAlign: TextAlign.center,
        ),
      ],
    ),
  )
else
  ...dashboard!['recent_bookings']!.map<Widget>((booking) {
    final customerName = booking['customer']?['name'] ?? 'Customer';
    final serviceTitle = booking['service']?['title'] ?? 'Service';
    final status = booking['status']?.toString() ?? 'pending';
    final amount = booking['amount']?.toString() ?? '0';
    final date = booking['booking_date']?.toString() ?? '';

    Color statusBg;
    switch (status.toLowerCase()) {
      case 'accepted':
        statusBg = Colors.blue;
        break;
      case 'completed':
        statusBg = Colors.green;
        break;
      case 'rejected':
      case 'cancelled':
        statusBg = Colors.red;
        break;
      default:
        statusBg = Colors.orange;
    }

    return Card(
      key: ValueKey(booking['id']),
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withOpacity(.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.person,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    customerName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    serviceTitle,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),
                  if (date.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      date,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "₹$amount",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusBg.withOpacity(.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status[0].toUpperCase() + status.substring(1),
                    style: TextStyle(
                      color: statusBg,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }).toList(),


const SizedBox(height: 30),

],
),
),
);
  }
Widget dashboardCard({
  required String title,
  required String value,
  required IconData icon,
}) {
  return Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(.08),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      children: [

        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .primary
                .withOpacity(.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 28,
          ),
        ),

        const SizedBox(height: 16),

        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          title,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

Widget _actionCard(
  BuildContext context,
  IconData icon,
  String title,
  VoidCallback onTap,
){
  return Material(
    color: Colors.white,
    elevation: 2,
    borderRadius: BorderRadius.circular(18),
    child: InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withOpacity(.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
    }