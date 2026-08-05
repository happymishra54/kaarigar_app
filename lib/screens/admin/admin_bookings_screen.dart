import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/admin_booking_model.dart';
import '../../providers/admin_booking_provider.dart';

class AdminBookingsScreen extends StatefulWidget {
  const AdminBookingsScreen({super.key});

  @override
  State<AdminBookingsScreen> createState() =>
      _AdminBookingsScreenState();
}

class _AdminBookingsScreenState
    extends State<AdminBookingsScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context
          .read<AdminBookingProvider>()
          .loadBookings();
    });
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {

      case "accepted":
        return Colors.blue;

      case "completed":
        return Colors.green;

      case "cancelled":
        return Colors.red;

      default:
        return Colors.orange;
    }
  }

  Future<void> _changeStatus(
      AdminBooking booking) async {

    String selectedStatus =
        booking.status;

    await showDialog(
      context: context,
      builder: (_) {

        return AlertDialog(
          title: const Text(
            "Update Booking Status",
          ),

          content: StatefulBuilder(
            builder: (context, setState) {

              return DropdownButton<String>(
                value: selectedStatus,
                isExpanded: true,
                items: const [

                  DropdownMenuItem(
                    value: "pending",
                    child: Text("Pending"),
                  ),

                  DropdownMenuItem(
                    value: "accepted",
                    child: Text("Accepted"),
                  ),

                  DropdownMenuItem(
                    value: "completed",
                    child: Text("Completed"),
                  ),

                  DropdownMenuItem(
                    value: "cancelled",
                    child: Text("Cancelled"),
                  ),

                ],
                onChanged: (value) {

                  if (value == null) return;

                  setState(() {
                    selectedStatus = value;
                  });

                },
              );
            },
          ),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () async {

                await context
                    .read<
                        AdminBookingProvider>()
                    .updateStatus(
                      id: booking.id,
                      status: selectedStatus,
                    );

                if (!mounted) return;

                Navigator.pop(context);

                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Booking Updated Successfully",
                    ),
                  ),
                );
              },
              child: const Text("Save"),
            ),

          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    final provider =
        context.watch<AdminBookingProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Bookings"),
      ),

      body: provider.loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () =>
                  provider.loadBookings(),

              child: ListView.builder(
                padding: const EdgeInsets.all(16),

                itemCount: provider.bookings.length,

                itemBuilder: (context, index) {

                  final booking =
                      provider.bookings[index];

                  return Card(
                    margin:
                        const EdgeInsets.only(
                      bottom: 16,
                    ),
                    elevation: 4,

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                              16),
                    ),

                    child: Padding(
                      padding:
                          const EdgeInsets.all(16),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [

                          Row(
                            children: [

                              Expanded(
                                child: Text(
                                  booking.bookingNumber,
                                  style:
                                      const TextStyle(
                                    fontSize: 18,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ),

                              Container(
                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration:
                                    BoxDecoration(
                                  color:
                                      _statusColor(
                                              booking
                                                  .status)
                                          .withValues(
                                              alpha: 0.15),
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                              20),
                                ),

                                child: Text(
                                  booking.status
                                      .toUpperCase(),
                                  style: TextStyle(
                                    color:
                                        _statusColor(
                                            booking
                                                .status),
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ),

                            ],
                          ),

                          const Divider(
                              height: 25),

                          Text(
                            "Customer : ${booking.customerName}",
                          ),

                          const SizedBox(height: 6),

                          Text(
                            "Worker : ${booking.workerName}",
                          ),

                          const SizedBox(height: 6),

                          Text(
                            "Service : ${booking.serviceName}",
                          ),

                          const SizedBox(height: 6),

                          Text(
                            "Date : ${booking.bookingDate}",
                          ),

                          const SizedBox(height: 6),

                          Text(
                            "Time : ${booking.bookingTime}",
                          ),

                          const SizedBox(height: 6),

                          Text(
                            "Address : ${booking.address}",
                          ),

                          const SizedBox(height: 6),

                          Text(
                            "Amount : ₹${booking.amount}",
                            style:
                                const TextStyle(
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 20),

                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .end,

                            children: [

                              Tooltip(
                                message:
                                    "Change Status",
                                child:
                                    IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color:
                                        Colors.blue,
                                  ),
                                  onPressed: () {
                                    _changeStatus(
                                        booking);
                                  },
                                ),
                              ),

                              Tooltip(
                                message:
                                    "Delete Booking",
                                child:
                                    IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color:
                                        Colors.red,
                                  ),
                                  onPressed:
                                      () async {
                                    final confirm =
                                        await showDialog<
                                            bool>(
                                      context:
                                          context,
                                      builder:
                                          (_) =>
                                              AlertDialog(
                                        title:
                                            const Text(
                                                "Delete Booking"),
                                        content:
                                            Text(
                                          "Delete booking ${booking.bookingNumber} permanently?",
                                        ),
                                        actions: [

                                          TextButton(
                                            onPressed:
                                                () {
                                              Navigator.pop(
                                                  context,
                                                  false);
                                            },
                                            child:
                                                const Text(
                                                    "Cancel"),
                                          ),

                                          ElevatedButton(
                                            style:
                                                ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.red,
                                              foregroundColor:
                                                  Colors.white,
                                            ),
                                            onPressed:
                                                () {
                                              Navigator.pop(
                                                  context,
                                                  true);
                                            },
                                            child:
                                                const Text(
                                                    "Delete"),
                                          ),

                                        ],
                                      ),
                                    );

                                    if (confirm ==
                                        true) {
                                      await provider
                                          .deleteBooking(
                                              booking
                                                  .id);

                                      if (context
                                          .mounted) {
                                        provider
                                            .loadBookings();
                                      }
                                    }
                                  },
                                ),
                              ),

                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
