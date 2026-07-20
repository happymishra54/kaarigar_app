import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() =>
      _MyBookingsScreenState();
}

class _MyBookingsScreenState
    extends State<MyBookingsScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {

      final token =
          context.read<AuthProvider>().token!;

      context
          .read<BookingProvider>()
          .loadBookings(token);

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

  @override
  Widget build(BuildContext context) {

    final provider =
        context.watch<BookingProvider>();

    return Scaffold(

      appBar: AppBar(
        title: const Text("My Bookings"),
      ),

      body: provider.loading

          ? const Center(
              child: CircularProgressIndicator(),
            )

          : ListView.builder(

              itemCount: provider.bookings.length,

              itemBuilder: (_, index) {

                final booking =
                    provider.bookings[index];

                return Card(

                  margin: const EdgeInsets.all(10),

                  child: ListTile(

                    title: Text(
                      booking.bookingNumber,
                    ),

                    subtitle: Column(

                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        Text(booking.bookingDate),

                        Text(booking.bookingTime),

                        Text("₹${booking.amount}"),

                      ],
                    ),

                    trailing: Chip(

                      backgroundColor:
                          statusColor(
                              booking.status),

                      label: Text(
                        booking.status,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),

                    ),

                  ),

                );

              },

            ),

    );

  }

}