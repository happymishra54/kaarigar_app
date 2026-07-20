class WorkerDashboardModel {
  final int pending;
  final int accepted;
  final int completed;

  WorkerDashboardModel({
    required this.pending,
    required this.accepted,
    required this.completed,
  });

  factory WorkerDashboardModel.fromJson(
      Map<String, dynamic> json) {
    return WorkerDashboardModel(
      pending: json["pending"] ?? 0,
      accepted: json["accepted"] ?? 0,
      completed: json["completed"] ?? 0,
    );
  }
}