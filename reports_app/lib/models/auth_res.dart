import 'dart:convert';

import 'package:reports_app/models/user.dart';

class AuthResData {
  bool success;
  String? message;
  AuthRes? authRes;

  AuthResData({required this.success, this.message, this.authRes});

  factory AuthResData.fromJson(String str) =>
      AuthResData.fromMap(json.decode(str) as Map<String, dynamic>);

  String toJson() => json.encode(toMap());

  factory AuthResData.fromMap(Map<String, dynamic> json) => AuthResData(
    success: json["success"] as bool,
    message: json["message"] as String?,
    authRes: json["data"] == null
        ? null
        : AuthRes.fromMap(json["data"] as Map<String, dynamic>),
  );

  Map<String, dynamic> toMap() => {
    "success": success,
    "message": message,
    "data": authRes?.toMap(),
  };
}

class AuthRes {
  String token;
  User user;

  AuthRes({required this.token, required this.user});

  factory AuthRes.fromJson(String str) =>
      AuthRes.fromMap(json.decode(str) as Map<String, dynamic>);

  String toJson() => json.encode(toMap());

  factory AuthRes.fromMap(Map<String, dynamic> json) => AuthRes(
    token: json["token"] as String,
    user: User.fromMap(json["user"] as Map<String, dynamic>),
  );

  Map<String, dynamic> toMap() => {"token": token, "user": user.toMap()};
}
