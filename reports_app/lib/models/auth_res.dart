import 'dart:convert';

import 'package:reports_app/models/user.dart';

class AuthRes {
  String token;
  User user;

  AuthRes({required this.token, required this.user});

  factory AuthRes.fromJson(String str) => AuthRes.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AuthRes.fromMap(Map<String, dynamic> json) =>
      AuthRes(token: json["token"], user: User.fromMap(json["user"]));

  Map<String, dynamic> toMap() => {"token": token, "user": user.toMap()};
}
