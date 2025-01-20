// To parse this JSON data, do
//
//     final paymentModel = paymentModelFromJson(jsonString);

import 'dart:convert';

PaymentModel paymentModelFromJson(String str) =>
    PaymentModel.fromJson(json.decode(str));

String paymentModelToJson(PaymentModel data) => json.encode(data.toJson());

class PaymentModel {
  String? msg;
  Data? data;
  dynamic err;
  String? status;

  PaymentModel({
    this.msg,
    this.data,
    this.err,
    this.status,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) => PaymentModel(
        msg: json["msg"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        err: json["err"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "msg": msg,
        "data": data?.toJson(),
        "err": err,
        "status": status,
      };
}

class Data {
  int? id;
  String? upiId;
  String? qrCode;
  Partner? partner;
  DateTime? created;
  DateTime? modified;

  Data({
    this.id,
    this.upiId,
    this.qrCode,
    this.partner,
    this.created,
    this.modified,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        upiId: json["upiID"],
        qrCode: json["qrCode"],
        partner:
            json["partner"] == null ? null : Partner.fromJson(json["partner"]),
        created:
            json["created"] == null ? null : DateTime.parse(json["created"]),
        modified:
            json["modified"] == null ? null : DateTime.parse(json["modified"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "upiID": upiId,
        "qrCode": qrCode,
        "partner": partner?.toJson(),
        "created": created?.toIso8601String(),
        "modified": modified?.toIso8601String(),
      };
}

class Partner {
  int? id;
  String? name;
  int? age;
  String? email;
  int? pinCode;
  String? phone;
  String? role;
  String? status;
  DateTime? created;
  dynamic modified;

  Partner({
    this.id,
    this.name,
    this.age,
    this.email,
    this.pinCode,
    this.phone,
    this.role,
    this.status,
    this.created,
    this.modified,
  });

  factory Partner.fromJson(Map<String, dynamic> json) => Partner(
        id: json["id"],
        name: json["name"],
        age: json["age"],
        email: json["email"],
        pinCode: json["pinCode"],
        phone: json["phone"],
        role: json["role"],
        status: json["status"],
        created:
            json["created"] == null ? null : DateTime.parse(json["created"]),
        modified: json["modified"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "age": age,
        "email": email,
        "pinCode": pinCode,
        "phone": phone,
        "role": role,
        "status": status,
        "created": created?.toIso8601String(),
        "modified": modified,
      };
}
