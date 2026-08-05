import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final VoidCallback onTap;

  const SearchBarWidget({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        color: Colors.white,
        elevation: 6,
        shadowColor: Colors.black.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xff2563EB).withValues(alpha: .10),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.search_rounded,
                    color: Color(0xff2563EB),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Search Services",
                        style: TextStyle(
                          color: Colors.grey.shade800,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        "Plumber, Electrician, Painter...",
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.tune_rounded,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
