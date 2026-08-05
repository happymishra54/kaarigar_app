class AdminBooking {
  final int id;
  final String bookingNumber;
  final String customerName;
  final String workerName;
  final String serviceName;
  final String bookingDate;
  final String bookingTime;
  final String address;
  final String amount;
  final String status;

  AdminBooking({
    required this.id,
    required this.bookingNumber,
    required this.customerName,
    required this.workerName,
    required this.serviceName,
    required this.bookingDate,
    required this.bookingTime,
    required this.address,
    required this.amount,
    required this.status,
  });

  factory AdminBooking.fromJson(Map<String, dynamic> json) {
    return AdminBooking(
      id: json["id"],

      bookingNumber:
          json["booking_number"]?.toString() ?? "",

      customerName:
          json["customer"]?["name"] ?? "Unknown",

      workerName:
          json["worker"]?["name"] ?? "Not Assigned",

      serviceName:
          json["service"]?["title"] ?? "Unknown",

      bookingDate:
          json["booking_date"] ?? "",

      bookingTime:
          json["booking_time"] ?? "",

      address:
          json["address"] ?? "",

      amount:
          json["amount"]?.toString() ?? "0",

      status:
          json["status"] ?? "pending",
    );
  }
}