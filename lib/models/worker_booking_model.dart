import 'package:flutter/material.dart';

/// A strongly-typed model representing a booking as seen by a worker.
class WorkerBookingModel {
  final int id;
  final String bookingNumber;
  final String bookingDate;
  final String bookingTime;
  final String address;
  final String amount;
  final String status;

  final String customerName;
  final String customerPhone;
  final String serviceTitle;

  const WorkerBookingModel({
    required this.id,
    required this.bookingNumber,
    required this.bookingDate,
    required this.bookingTime,
    required this.address,
    required this.amount,
    required this.status,
    required this.customerName,
    required this.customerPhone,
    required this.serviceTitle,
  });

  factory WorkerBookingModel.fromJson(Map<String, dynamic> json) {
    return WorkerBookingModel(
      id: json["id"] ?? 0,
      bookingNumber: json["booking_number"]?.toString() ?? "",
      bookingDate: json["booking_date"]?.toString() ?? "",
      bookingTime: json["booking_time"]?.toString() ?? "",
      address: json["address"]?.toString() ?? "",
      amount: json["amount"]?.toString() ?? "0",
      status: json["status"]?.toString() ?? "",
      customerName: json["customer"]?["name"]?.toString() ?? "",
      customerPhone: json["customer"]?["phone"]?.toString() ?? "",
      serviceTitle: json["service"]?["title"]?.toString() ?? "",
    );
  }

  bool get isPending => status.toLowerCase() == 'pending';
  bool get isAccepted => status.toLowerCase() == 'accepted';
  bool get isCompleted => status.toLowerCase() == 'completed';
  bool get isRejected =>
      status.toLowerCase() == 'rejected' || status.toLowerCase() == 'cancelled';

  String get statusLabel {
    if (status.isEmpty) return "Unknown";
    return status[0].toUpperCase() + status.substring(1);
  }

  Color get statusColor {
    switch (status.toLowerCase()) {
      case 'accepted':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'rejected':
      case 'cancelled':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
