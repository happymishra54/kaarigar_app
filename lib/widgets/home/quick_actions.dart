import 'package:flutter/material.dart';

class QuickActions extends StatelessWidget {
  final VoidCallback onBookings;
  final VoidCallback onProfile;
  final VoidCallback onNearby;
  final VoidCallback onFavorites;

  const QuickActions({
    super.key,
    required this.onBookings,
    required this.onProfile,
    required this.onNearby,
    required this.onFavorites,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Quick Actions",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _ActionCard(
                  title: "Bookings",
                  subtitle: "Track jobs",
                  icon: Icons.receipt_long,
                  color: const Color(0xff2563EB),
                  onTap: onBookings,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _ActionCard(
                  title: "Profile",
                  subtitle: "Manage account",
                  icon: Icons.person,
                  color: Colors.orange,
                  onTap: onProfile,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _ActionCard(
                  title: "Nearby",
                  subtitle: "Workers",
                  icon: Icons.location_on,
                  color: Colors.green,
                  onTap: onNearby,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _ActionCard(
                  title: "Favorites",
                  subtitle: "Workers",
                  icon: Icons.favorite,
                  color: Colors.red,
                  onTap: onFavorites,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
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
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
