class BookingModel {
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

  final String workerName;
  final String workerPhone;

  BookingModel({
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
    required this.workerName,
    required this.workerPhone,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json["id"],

      bookingNumber: json["booking_number"] ?? "",

      bookingDate: json["booking_date"] ?? "",

      bookingTime: json["booking_time"] ?? "",

      address: json["address"] ?? "",

      amount: json["amount"].toString(),

      status: json["status"] ?? "",

      customerName: json["customer"]?["name"] ?? "",

      customerPhone: json["customer"]?["phone"] ?? "",

      serviceTitle: json["service"]?["title"] ?? "",

      workerName: json["worker"]?["name"] ?? "",

      workerPhone: json["worker"]?["phone"] ?? "",
    );
  }
}
