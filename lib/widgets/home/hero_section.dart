import 'package:flutter/material.dart';

class HeroSection extends StatelessWidget {
  final String name;

  final VoidCallback onSearch;

  const HeroSection({
    super.key,
    required this.name,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xff2563EB),
            Color(0xff1D4ED8),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(35),
          bottomRight: Radius.circular(35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.handyman_rounded,
                  color: Color(0xff2563EB),
                  size: 32,
                ),
              ),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .15),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.notifications_none,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          const Text(
            "Good Afternoon 👋",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "What service do you need today?",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 30),
          GestureDetector(
            onTap: onSearch,
            child: Container(
              height: 58,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.search,
                    color: Color(0xff2563EB),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      "Search plumber, electrician...",
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.tune,
                    color: Colors.grey.shade700,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
