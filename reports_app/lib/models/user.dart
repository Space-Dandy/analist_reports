import 'dart:convert';

class UserData {
  List<User> data;

  UserData({required this.data});

  factory UserData.fromJson(String str) => UserData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserData.fromMap(Map<String, dynamic> json) =>
      UserData(data: List<User>.from(json["data"].map((x) => User.fromMap(x))));

  Map<String, dynamic> toMap() => {
    "data": List<dynamic>.from(data.map((x) => x.toMap())),
  };
}

class User {
  int id;
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
