import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/booking_model.dart';
import '../../providers/booking_provider.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) return;
      context.read<BookingProvider>().loadBookings();
    });
  }

  Color statusColor(String status) {
    switch (status) {
      case "Completed":
        return Colors.green;
      case "Accepted":
        return Colors.blue;
      case "Cancelled":
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  Future<void> _callWorker(String phone) async {
    if (phone.isEmpty) return;

    final telUri = Uri(scheme: 'tel', path: phone);

    final canLaunch = await canLaunchUrl(telUri);

    if (!canLaunch) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Unable to place the call"),
        ),
      );
      return;
    }

    await launchUrl(telUri);
  }

  Future<void> _showBookingDetails(BookingModel booking) async {
    final color = statusColor(booking.status);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(28),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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

              Row(
                children: [
                  Expanded(
                    child: Text(
                      booking.bookingNumber,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: .15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      booking.status.toUpperCase(),
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),

              const Divider(height: 30),

              // ---- Worker Section ----
              Row(
                children: [
                  const Icon(
                    Icons.person,
                    color: Color(0xff2563EB),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Worker",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xffF5F7FB),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: booking.workerName.isEmpty
                    ? const Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.grey),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "No worker assigned yet",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          const CircleAvatar(
                            radius: 24,
                            backgroundColor: Color(0xff2563EB),
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  booking.workerName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  booking.workerPhone.isEmpty
                                      ? "Phone not available"
                                      : booking.workerPhone,
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (booking.workerPhone.isNotEmpty)
                            IconButton.filled(
                              tooltip: "Call Worker",
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () => _callWorker(
                                booking.workerPhone,
                              ),
                              icon: const Icon(Icons.call),
                            ),
                        ],
                      ),
              ),

              const SizedBox(height: 24),

              // ---- Booking Info ----
              Row(
                children: [
                  const Icon(
                    Icons.receipt_long,
                    color: Color(0xff2563EB),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Booking Details",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              _infoRow(
                Icons.category,
                "Service",
                booking.serviceTitle.isEmpty
                    ? "N/A"
                    : booking.serviceTitle,
              ),
              _infoRow(
                Icons.event,
                "Date",
                booking.bookingDate,
              ),
              _infoRow(
                Icons.access_time,
                "Time",
                booking.bookingTime,
              ),
              _infoRow(
                Icons.location_on_outlined,
                "Address",
                booking.address.isEmpty ? "N/A" : booking.address,
              ),
              _infoRow(
                Icons.currency_rupee,
                "Amount",
                "₹${booking.amount}",
                highlight: true,
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  label: const Text("Close"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(
    IconData icon,
    String label,
    String value, {
    bool highlight = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight:
                    highlight ? FontWeight.bold : FontWeight.w500,
                fontSize: highlight ? 16 : 14,
                color: highlight
                    ? const Color(0xff2563EB)
                    : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookingProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Bookings"),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await provider.loadBookings();
        },
        child: provider.loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : provider.error != null
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      const SizedBox(height: 120),
                      const Icon(
                        Icons.error_outline,
                        size: 80,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Failed to load bookings",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        provider.error!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () => provider.loadBookings(),
                          icon: const Icon(Icons.refresh),
                          label: const Text("Retry"),
                        ),
                      ),
                    ],
                  )
                : provider.bookings.isEmpty
                    ? ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: const [
                          SizedBox(height: 120),
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 80,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 20),
                          Text(
                            "No bookings found",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Book a service to see your bookings here.",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      )
                    : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(10),
                        itemCount: provider.bookings.length,
                        itemBuilder: (_, index) {
                          final booking = provider.bookings[index];

                          return Card(
                            margin: const EdgeInsets.all(10),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () => _showBookingDetails(booking),
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            booking.bookingNumber,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            booking.serviceTitle.isEmpty
                                                ? "Service"
                                                : booking.serviceTitle,
                                            style: TextStyle(
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            "${booking.bookingDate} • ${booking.bookingTime}",
                                            style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 13,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            "₹${booking.amount}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff2563EB),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Chip(
                                          backgroundColor: statusColor(
                                            booking.status,
                                          ),
                                          label: Text(
                                            booking.status,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisSize:
                                              MainAxisSize.min,
                                          children: [
                                            if (booking.workerName.isNotEmpty)
                                              Text(
                                                booking.workerName,
                                                style: TextStyle(
                                                  color: Colors.grey
                                                      .shade600,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            const SizedBox(width: 4),
                                            const Icon(
                                              Icons.chevron_right,
                                              color: Colors.grey,
                                              size: 20,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
      ),
    );
  }
}
