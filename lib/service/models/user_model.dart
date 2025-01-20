// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  int? id;
  String? name;
  int? age;
  String? city;
  String? email;
  int? pinCode;
  String? phone;
  String? role;
  String? status;
  DateTime? created;
  dynamic modified;
  String? clientID;

  UserModel(
      {this.id,
      this.name,
      this.age,
      this.city,
      this.email,
      this.pinCode,
      this.phone,
      this.role,
      this.status,
      this.created,
      this.modified,
      this.clientID});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      id: json["id"],
      name: json["name"],
      age: json["age"],
      city: json["city"],
      email: json["email"],
      pinCode: json["pinCode"],
      phone: json["phone"],
      role: json["role"],
      status: json["status"],
      created: json["created"] == null ? null : DateTime.parse(json["created"]),
      modified: json["modified"],
      clientID: json["clientID"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "age": age,
        "city": city,
        "email": email,
        "pinCode": pinCode,
        "phone": phone,
        "role": role,
        "status": status,
        "created": created?.toIso8601String(),
        "modified": modified,
        "clientID": clientID
      };
}
