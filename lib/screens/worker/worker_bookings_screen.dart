import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/worker_booking_model.dart';
import '../../providers/worker_booking_provider.dart';

class WorkerBookingsScreen extends StatefulWidget {
  const WorkerBookingsScreen({super.key});

  @override
  State<WorkerBookingsScreen> createState() => _WorkerBookingsScreenState();
}

class _WorkerBookingsScreenState extends State<WorkerBookingsScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<WorkerBookingProvider>().loadBookings();
      }
    });
  }

  Future<void> _callCustomer(String phone) async {
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

  Future<void> _showBookingDetails(WorkerBookingModel booking) async {
    final color = booking.statusColor;

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
                      booking.bookingNumber.isEmpty
                          ? "Booking Details"
                          : booking.bookingNumber,
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
                      booking.statusLabel,
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

              // ---- Customer Section ----
              const Row(
                children: [
                  Icon(
                    Icons.person,
                    color: Color(0xff2563EB),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Customer",
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
                child: Row(
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
                            booking.customerName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            booking.customerPhone.isEmpty
                                ? "Phone not available"
                                : booking.customerPhone,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (booking.customerPhone.isNotEmpty)
                      IconButton.filled(
                        tooltip: "Call Customer",
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () =>
                            _callCustomer(booking.customerPhone),
                        icon: const Icon(Icons.call),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ---- Booking Info ----
              const Row(
                children: [
                  Icon(
                    Icons.receipt_long,
                    color: Color(0xff2563EB),
                  ),
                  SizedBox(width: 10),
                  Text(
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
                booking.serviceTitle,
              ),
              _infoRow(
                Icons.event,
                "Date",
                booking.bookingDate,
              ),
              if (booking.bookingTime.isNotEmpty)
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
                fontWeight: highlight ? FontWeight.bold : FontWeight.w500,
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

  Widget _buildBookingCard(
    WorkerBookingModel booking,
    WorkerBookingProvider provider,
  ) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => _showBookingDetails(booking),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xff2563EB).withValues(alpha: .1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Color(0xff2563EB),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.customerName,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          booking.serviceTitle,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                        if (booking.bookingDate.isNotEmpty) ...[
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              Icon(
                                Icons.event,
                                size: 14,
                                color: Colors.grey.shade500,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                booking.bookingTime.isEmpty
                                    ? booking.bookingDate
                                    : "${booking.bookingDate} • ${booking.bookingTime}",
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: booking.statusColor.withValues(alpha: .13),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      booking.statusLabel,
                      style: TextStyle(
                        color: booking.statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Text(
                    "₹${booking.amount}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  if (booking.isPending) ...[
                    SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () => provider.acceptBooking(booking.id),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 22),
                        ),
                        child: const Text("Accept"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () => provider.rejectBooking(booking.id),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 22),
                        ),
                        child: const Text("Reject"),
                      ),
                    ),
                  ] else if (booking.isAccepted)
                    SizedBox(
                      height: 40,
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            provider.completeBooking(booking.id),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                        icon: const Icon(Icons.check_circle, size: 18),
                        label: const Text("Complete"),
                      ),
                    )
                  else
                    ElevatedButton.icon(
                      onPressed: () => _showBookingDetails(booking),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor:
                            const Color(0xff2563EB).withValues(alpha: .1),
                        foregroundColor: const Color(0xff2563EB),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                      ),
                      icon: const Icon(Icons.visibility, size: 18),
                      label: const Text("View"),
                    ),
                ],
              ),

              if (booking.customerPhone.isNotEmpty) ...[
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () => _callCustomer(booking.customerPhone),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: .1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.call,
                              color: Colors.green,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              booking.customerPhone,
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WorkerBookingProvider>();
    final bookings = provider.bookings;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Worker Bookings",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
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
                : bookings.isEmpty
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
                            "New bookings from customers will appear here.",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      )
                    : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(16),
                        itemCount: bookings.length,
                        itemBuilder: (context, index) {
                          final booking = bookings[index];
                          return _buildBookingCard(booking, provider);
                        },
                      ),
      ),
    );
  }
}
