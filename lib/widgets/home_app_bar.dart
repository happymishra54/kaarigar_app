import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  final String name;
  final VoidCallback? onBookings;
  final VoidCallback? onProfile;

  const HomeAppBar({
    super.key,
    required this.name,
    this.onBookings,
    this.onProfile,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(24),

      decoration: BoxDecoration(

        gradient: const LinearGradient(
          colors: [
            Color(0xff2563EB),
            Color(0xff1D4ED8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

borderRadius: BorderRadius.circular(24),

        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: .25),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Row(

            children: [

              Container(

                width: 65,
                height: 65,

                decoration: BoxDecoration(

                  color: Colors.white,

                  borderRadius:
                      BorderRadius.circular(18),

                ),

                child: const Icon(
                  Icons.person,
                  size: 36,
                  color: Color(0xff2563EB),
                ),

              ),

              const SizedBox(width: 18),

              Expanded(

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    const Text(

                      "WELCOME BACK 👋",

                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w600,
                      ),

                    ),

                    const SizedBox(height: 6),

                    Text(

                      name,

                      maxLines: 1,

                      overflow:
                          TextOverflow.ellipsis,

                      style: const TextStyle(

                        color: Colors.white,

                        fontSize: 26,

                        fontWeight: FontWeight.bold,

                      ),

                    ),

                    const SizedBox(height: 4),

                    const Text(

                      "Find trusted professionals near your location",

                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),

                    ),

                  ],

                ),

              ),

            ],

          ),

          const SizedBox(height: 28),

          Row(

            children: [

              Expanded(

                child: ElevatedButton.icon(

                  onPressed: onBookings,

                  style: ElevatedButton.styleFrom(

                    backgroundColor: Colors.white,

                    foregroundColor:
                        const Color(0xff2563EB),

                    elevation: 0,

                    minimumSize:
                        const Size.fromHeight(52),

                    shape:
                        RoundedRectangleBorder(

                      borderRadius:
                          BorderRadius.circular(14),

                    ),

                  ),

                  icon: const Icon(
                    Icons.receipt_long,
                  ),

                  label: const Text(

                    "My Bookings",

                    style: TextStyle(
                      fontWeight:
                          FontWeight.bold,
                    ),

                  ),

                ),

              ),

              const SizedBox(width: 14),

              Expanded(

                child: OutlinedButton.icon(

                  onPressed: onProfile,

                  style: OutlinedButton.styleFrom(

                    foregroundColor:
                        Colors.white,

                    minimumSize:
                        const Size.fromHeight(52),

                    side: const BorderSide(
                      color: Colors.white,
                    ),

                    shape:
                        RoundedRectangleBorder(

                      borderRadius:
                          BorderRadius.circular(14),

                    ),

                  ),

                  icon: const Icon(
                    Icons.person_outline,
                  ),

                  label: const Text(

                    "Profile",

                    style: TextStyle(
                      fontWeight:
                          FontWeight.bold,
                    ),

                  ),

                ),

              ),

            ],

          ),

        ],

      ),

    );

  }

}