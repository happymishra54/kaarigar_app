import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/service_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';

class BookServiceScreen extends StatefulWidget {
  final ServiceModel service;

  const BookServiceScreen({
    super.key,
    required this.service,
  });

  @override
  State<BookServiceScreen> createState() => _BookServiceScreenState();
}

class _BookServiceScreenState extends State<BookServiceScreen> {
  final _formKey = GlobalKey<FormState>();

  final addressController = TextEditingController();

  DateTime? selectedDate;

  TimeOfDay? selectedTime;

  @override
  void dispose() {
    addressController.dispose();
    super.dispose();
  }

  Future<void> bookService() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select date and time"),
        ),
      );
      return;
    }

    final auth = context.read<AuthProvider>();

    final booking = context.read<BookingProvider>();

    try {
      await booking.createBooking(
        token: auth.token!,
        serviceId: widget.service.id,
        bookingDate:
            "${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}",
        bookingTime:
            "${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}",
        address: addressController.text.trim(),
      );

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Booking Successful"),
          content: const Text(
            "Your booking has been sent to the worker.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text("OK"),
            )
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  Future<void> pickDate() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
      initialDate: DateTime.now(),
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  Future<void> pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      setState(() {
        selectedTime = time;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final booking = context.watch<BookingProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Service"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Card(
                child: ListTile(
                  title: Text(widget.service.title),
                  subtitle: Text("₹${widget.service.price}"),
                ),
              ),

              const SizedBox(height: 25),

              ListTile(
                leading: const Icon(Icons.calendar_month),
                title: Text(
                  selectedDate == null
                      ? "Choose Booking Date"
                      : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: pickDate,
              ),

              const SizedBox(height: 15),

              ListTile(
                leading: const Icon(Icons.access_time),
                title: Text(
                  selectedTime == null
                      ? "Choose Booking Time"
                      : selectedTime!.format(context),
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: pickTime,
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: addressController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Service Address",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter address";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed:
                      booking.loading ? null : bookService,
                  child: booking.loading
                      ? const CircularProgressIndicator()
                      : const Text(
                          "CONFIRM BOOKING",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}