// lib/models/login_response.dart

import 'user_model.dart';

class LoginResponse {
  final String status;
  final String message;
  final User user;
  final String token;
  final String expiresAt;

  LoginResponse({
    required this.status,
    required this.message,
    required this.user,
    required this.token,
    required this.expiresAt,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'],
      message: json['message'],
      user: User.fromJson(json['user']),
      token: json['token'],
      expiresAt: json['expires_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'user': user.toJson(),
      'token': token,
      'expires_at': expiresAt,
    };
  }
}
