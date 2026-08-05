import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/worker_booking_provider.dart';
import 'worker_dashboard_screen.dart';
import 'my_services_screen.dart';
import 'worker_bookings_screen.dart';
import '../profile/profile_screen.dart';

class WorkerBottomNav extends StatefulWidget {
  final Map<String, dynamic>? profile;

  const WorkerBottomNav({
    super.key,
    this.profile,
  });

  @override
  State<WorkerBottomNav> createState() => _WorkerBottomNavState();
}

class _WorkerBottomNavState extends State<WorkerBottomNav> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      WorkerDashboardScreen(profile: widget.profile),
      const MyServicesScreen(),
      const WorkerBookingsScreen(),
      const ProfileScreen(),
    ];
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

// Reload bookings data whenever user switches to bookings tab
    if (index == 2) {
      context.read<WorkerBookingProvider>().loadBookings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build_outlined),
            activeIcon: Icon(Icons.build),
            label: "Services",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: "Bookings",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}

