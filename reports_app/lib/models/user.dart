import 'dart:convert';

class UserData {
  List<User>? data;
  bool success;
  String? message;

  UserData({required this.data, required this.success, required this.message});

  factory UserData.fromJson(String str) => UserData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserData.fromMap(Map<String, dynamic> json) => UserData(
    data: json["data"] == null
        ? null
        : List<User>.from(json["data"].map((x) => User.fromMap(x))),
    success: json["success"],
    message: json["message"],
  );

  Map<String, dynamic> toMap() => {
    "data": data == null
        ? null
        : List<dynamic>.from(data!.map((x) => x.toMap())),
    "success": success,
    "message": message,
  };
}

class CreateUserRes {
  bool success;
  User? data;
  String? message;

  CreateUserRes({
    required this.data,
    required this.success,
    required this.message,
  });

  factory CreateUserRes.fromJson(String str) =>
      CreateUserRes.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CreateUserRes.fromMap(Map<String, dynamic> json) => CreateUserRes(
    data: json["data"] == null ? null : User.fromMap(json["data"]),
    success: json["success"],
    message: json["message"],
  );

  Map<String, dynamic> toMap() => {
    "data": data?.toMap(),
    "success": success,
    "message": message,
  };
}

class User {
  int? id;
  String email;
  String name;
  int age;
  int position;
  String passwordHash;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.age,
    required this.position,
    required this.passwordHash,
  });

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) => User(
    id: json["id"],
    email: json["email"],
    name: json["name"],
    age: json["age"],
    position: json["position"],
    passwordHash: json["passwordHash"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "email": email,
    "name": name,
    "age": age,
    "position": position,
    "passwordHash": passwordHash,
  };
}
