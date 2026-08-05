import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import '../../models/top_worker_model.dart';
import '../../providers/home_provider.dart';

import '../../widgets/home/hero_section.dart';
import '../../widgets/home/quick_actions.dart';

import '../../widgets/category_list.dart';
import '../../widgets/service_card.dart';

import '../booking/my_bookings_screen.dart';
import '../profile/profile_screen.dart';

import '../search/search_results_screen.dart';
import '../search/category_services_screen.dart';
import '../search/nearby_workers_screen.dart';
import '../search/favorite_workers_screen.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  final storage = const FlutterSecureStorage();

  String name = "";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    name = await storage.read(key: "name") ?? "Customer";

    if (!mounted) return;

    await context.read<HomeProvider>().loadHome();

    setState(() {});
  }

  Future<void> _openSearch() async {
    final controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Search Services"),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: "Search plumber, electrician...",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isEmpty) return;

                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SearchResultsScreen(
                      query: controller.text.trim(),
                    ),
                  ),
                );
              },
              child: const Text("Search"),
            ),
          ],
        );
      },
    );
  }

  Widget _sectionContent({
    required bool loading,
    required String? error,
    required VoidCallback onRetry,
    required Widget child,
  }) {
    if (loading) {
      return const Padding(
        padding: EdgeInsets.all(40),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (error != null) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.cloud_off,
                size: 48,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 12),
              const Text(
                "Couldn't load content",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                error,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 14),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text("Retry"),
              ),
            ],
          ),
        ),
      );
    }

    return child;
  }

  @override
  Widget build(BuildContext context) {
    final home = context.watch<HomeProvider>();

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
      body: RefreshIndicator(
        onRefresh: () async {
          await home.loadHome();
        },
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            HeroSection(
              name: name,
              onSearch: _openSearch,
            ),

            const SizedBox(height: 25),

            QuickActions(
              onBookings: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MyBookingsScreen(),
                  ),
                );
              },
              onProfile: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProfileScreen(),
                  ),
                );
              },
              onNearby: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NearbyWorkersScreen(),
                  ),
                );
              },
              onFavorites: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FavoriteWorkersScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Popular Categories",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text("See All"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            _sectionContent(
              loading: home.loading,
              error: home.error,
              onRetry: () => context.read<HomeProvider>().loadHome(),
              child: CategoryList(
                categories: home.categories,
                onCategoryTap: (category) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CategoryServicesScreen(
                        category: category,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 35),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xff2563EB),
                    Color(0xff1D4ED8),
                  ],
                ),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Need a professional?",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Book trusted workers in just a few taps.",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.handyman_rounded,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 35),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Featured Services",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text("See All"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            _sectionContent(
              loading: home.loading,
              error: home.error,
              onRetry: () => context.read<HomeProvider>().loadHome(),
              child: Column(
                children: home.services
                    .map(
                      (service) => Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        child: ServiceCard(
                          service: service,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Top Rated Workers",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text("View All"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            if (home.topWorkers.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Text(
                  "No top-rated workers available yet.",
                  style: TextStyle(
                    color: Color(0xff8190A5),
                    fontSize: 15,
                  ),
                ),
              )
            else
              SizedBox(
                height: 210,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    for (var i = 0; i < home.topWorkers.length; i++) ...[
                      if (i > 0) const SizedBox(width: 15),
                      _workerCard(worker: home.topWorkers[i]),
                    ],
                  ],
                ),
              ),

            const SizedBox(height: 30),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .05),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Why Choose Kaarigar?",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _featureTile(
                    Icons.verified_user,
                    "Verified Workers",
                    "Every worker is verified by our admin team.",
                    Colors.green,
                  ),
                  const SizedBox(height: 15),
                  _featureTile(
                    Icons.schedule,
                    "Quick Booking",
                    "Book trusted workers within minutes.",
                    Colors.orange,
                  ),
                  const SizedBox(height: 15),
                  _featureTile(
                    Icons.payments,
                    "Affordable Pricing",
                    "Transparent pricing with no hidden charges.",
                    Colors.blue,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.handyman_rounded,
                    color: Colors.blue.shade700,
                    size: 40,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Kaarigar",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Trusted local professionals at your fingertips.",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _workerCard({required TopWorkerModel worker}) {
    return Container(
      width: 170,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipOval(
            child: worker.profileImage.isNotEmpty
                ? Image.network(
                    worker.profileImage,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const CircleAvatar(
                      radius: 25,
                      backgroundColor: Color(0xff2563EB),
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  )
                : const CircleAvatar(
                    radius: 25,
                    backgroundColor: Color(0xff2563EB),
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
          ),
          const SizedBox(height: 8),
          Text(
            worker.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            worker.profession,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13,
            ),
          ),
          if (worker.city.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              worker.city,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 12,
              ),
            ),
          ],
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.star,
                color: Colors.amber,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                worker.rating > 0
                    ? worker.rating.toStringAsFixed(1)
                    : "New",
                style: const TextStyle(fontSize: 14),
              ),
              if (worker.reviewsCount > 0) ...[
                const SizedBox(width: 4),
                Text(
                  "(${worker.reviewsCount})",
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 6),
          if (worker.dailyWage.isNotEmpty)
            Text(
              worker.dailyWage,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xff2563EB),
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 34,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                textStyle: const TextStyle(fontSize: 14),
              ),
              child: const Text("View"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _featureTile(
    IconData icon,
    String title,
    String subtitle,
    Color color,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withValues(alpha: .12),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(icon, color: color),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
