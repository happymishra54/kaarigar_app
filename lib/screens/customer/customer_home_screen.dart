import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import '../booking/my_bookings_screen.dart';
import '../../providers/home_provider.dart';
import '../../widgets/category_list.dart';
import '../../widgets/home_app_bar.dart';
import '../../widgets/search_bar_widget.dart';
import '../../widgets/service_card.dart';
import '../profile/profile_screen.dart';
import '../search/search_results_screen.dart';
import '../search/category_services_screen.dart';

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

  @override
  Widget build(BuildContext context) {

    final home = context.watch<HomeProvider>();

    return Scaffold(

  appBar: AppBar(
    title: const Text("Kaarigar"),
    centerTitle: true,
    actions: [

      IconButton(
        icon: const Icon(Icons.receipt_long),
        tooltip: "My Bookings",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const MyBookingsScreen(),
            ),
          );
        },
      ),

    ],
  ),

  body: RefreshIndicator(

    onRefresh: () async {
      await home.loadHome();
    },

    child: ListView(

      children: [

        HomeAppBar(
  name: name,

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
),

        const SizedBox(height: 10),

        SearchBarWidget(
          onTap: () {
            final searchController = TextEditingController();
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text("Search Services"),
                content: TextField(
                  controller: searchController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: "Search for services...",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      Navigator.pop(ctx);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SearchResultsScreen(
                            query: value.trim(),
                          ),
                        ),
                      );
                    }
                  },
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (searchController.text.trim().isNotEmpty) {
                        Navigator.pop(ctx);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SearchResultsScreen(
                              query: searchController.text.trim(),
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text("Search"),
                  ),
                ],
              ),
            );
          },
        ),

        const SizedBox(height: 25),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Categories",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),

        const SizedBox(height: 15),

        if (home.loading)

          const Center(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: CircularProgressIndicator(),
            ),
          )

        else

          CategoryList(
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

        const SizedBox(height: 20),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Popular Services",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),

        const SizedBox(height: 15),

        ...home.services.map(
          (service) => ServiceCard(
            service: service,
          ),
        ),

        const SizedBox(height: 20),

      ],

    ),

  ),

);

  }
}