import 'user_model.dart';

class WorkerModel {
  final UserModel user;

  WorkerModel({
    required this.user,
  });

  factory WorkerModel.fromJson(Map<String, dynamic> json) {
    return WorkerModel(
      user: UserModel.fromJson(json),
    );
  }
}