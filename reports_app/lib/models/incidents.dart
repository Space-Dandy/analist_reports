import 'dart:convert';

class IncidentsRes {
  bool success;
  List<Incident> data;
  dynamic message;

  IncidentsRes({
    required this.success,
    required this.data,
    required this.message,
  });

  factory IncidentsRes.fromJson(String str) =>
      IncidentsRes.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory IncidentsRes.fromMap(Map<String, dynamic> json) => IncidentsRes(
    success: json["success"],
    data: List<Incident>.from(json["data"].map((x) => Incident.fromMap(x))),
    message: json["message"],
  );

  Map<String, dynamic> toMap() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toMap())),
    "message": message,
  };
}

class IncidentResolveRes {
  bool success;
  Incident data;
  String? message;

  IncidentResolveRes({
    required this.success,
    required this.data,
    required this.message,
  });

  factory IncidentResolveRes.fromJson(String str) =>
      IncidentResolveRes.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory IncidentResolveRes.fromMap(Map<String, dynamic> json) =>
      IncidentResolveRes(
        success: json["success"],
        data: Incident.fromMap(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toMap() => {
    "success": success,
    "data": data.toMap(),
    "message": message,
  };
}

class Incident {
  int id;
  int userId;
  String userName;
  String folioNumber;
  String title;
  String description;
  String dateReported;
  int status;
  String imagePath;
  int? authUserId;
  String? authUserName;
  String? resolutionDate;

  Incident({
    required this.id,
    required this.userId,
    required this.userName,
    required this.folioNumber,
    required this.title,
    required this.description,
    required this.dateReported,
    required this.status,
    required this.imagePath,
    required this.authUserId,
    required this.authUserName,
    required this.resolutionDate,
  });

  factory Incident.fromJson(String str) => Incident.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Incident.fromMap(Map<String, dynamic> json) => Incident(
    id: json["id"],
    userId: json["userId"],
    userName: json["userName"],
    folioNumber: json["folioNumber"],
    title: json["title"],
    description: json["description"],
    dateReported: json["dateReported"],
    status: json["status"],
    imagePath: json["imagePath"],
    authUserId: json["authUserId"],
    authUserName: json["authUserName"],
    resolutionDate: json["resolutionDate"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "userId": userId,
    "userName": userName,
    "folioNumber": folioNumber,
    "title": title,
    "description": description,
    "dateReported": dateReported,
    "status": status,
    "imagePath": imagePath,
    "authUserId": authUserId,
    "authUserName": authUserName,
    "resolutionDate": resolutionDate,
  };
}
