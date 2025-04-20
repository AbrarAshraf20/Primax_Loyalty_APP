
import 'user_model.dart';

class ProfileResponse {
  final String status;
  final User user;

  ProfileResponse({required this.status, required this.user});

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      status: json['status'],
      user: User.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'user': user.toJson(),
    };
  }
}