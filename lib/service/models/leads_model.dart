// To parse this JSON data, do
//
//     final myLeadsModel = myLeadsModelFromJson(jsonString);

import 'dart:convert';

MyLeadsModel myLeadsModelFromJson(String str) =>
    MyLeadsModel.fromJson(json.decode(str));

String myLeadsModelToJson(MyLeadsModel data) => json.encode(data.toJson());

class MyLeadsModel {
  List<Content>? content;
  int? pageNumber;
  int? pageSize;
  int? totalElements;
  int? totalPages;
  bool? lastPage;

  MyLeadsModel({
    this.content,
    this.pageNumber,
    this.pageSize,
    this.totalElements,
    this.totalPages,
    this.lastPage,
  });

  factory MyLeadsModel.fromJson(Map<String, dynamic> json) => MyLeadsModel(
        content: json["content"] == null
            ? []
            : List<Content>.from(
                json["content"]!.map((x) => Content.fromJson(x))),
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        totalElements: json["totalElements"],
        totalPages: json["totalPages"],
        lastPage: json["lastPage"],
      );

  Map<String, dynamic> toJson() => {
        "content": content == null
            ? []
            : List<dynamic>.from(content!.map((x) => x.toJson())),
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "totalElements": totalElements,
        "totalPages": totalPages,
        "lastPage": lastPage,
      };
}

class Content {
  int? id;
  LeadProvider? leadProvider;
  String? clientName;
  String? vehicle;
  String? phoneNumber;
  String? city;
  String? isFinanceInterested;
  bool? interested;
  DateTime? time;
  dynamic updated;
  dynamic expectedEarnings;
  dynamic partnersTake;
  dynamic leadNote;
  dynamic noteForPrt;
  int? takePaid;
  dynamic txnId;
  dynamic leadClosedOn;
  bool? deleted;
  dynamic paymentStatus;
  String? status;
  bool? didAdminCalled;
  bool? didUserAnswered;
  dynamic lastCallTime;
  String? notes;
  int? priority;

  Content({
    this.id,
    this.leadProvider,
    this.clientName,
    this.vehicle,
    this.phoneNumber,
    this.city,
    this.isFinanceInterested,
    this.interested,
    this.time,
    this.updated,
    this.expectedEarnings,
    this.partnersTake,
    this.leadNote,
    this.noteForPrt,
    this.takePaid,
    this.txnId,
    this.leadClosedOn,
    this.deleted,
    this.paymentStatus,
    this.status,
    this.didAdminCalled,
    this.didUserAnswered,
    this.lastCallTime,
    this.notes,
    this.priority,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        id: json["id"],
        leadProvider: json["leadProvider"] == null
            ? null
            : LeadProvider.fromJson(json["leadProvider"]),
        clientName: json["clientName"],
        vehicle: json["vehicle"],
        phoneNumber: json["phoneNumber"],
        city: json["city"],
        isFinanceInterested: json["isFinanceInterested"],
        interested: json["interested"],
        time: json["time"] == null ? null : DateTime.parse(json["time"]),
        updated: json["updated"],
        expectedEarnings: json["expectedEarnings"],
        partnersTake: json["partnersTake"],
        leadNote: json["leadNote"],
        noteForPrt: json["noteForPrt"],
        takePaid: json["takePaid"],
        txnId: json["txnID"],
        leadClosedOn: json["leadClosedOn"],
        deleted: json["deleted"],
        paymentStatus: json["paymentStatus"],
        status: json["status"],
        didAdminCalled: json["didAdminCalled"],
        didUserAnswered: json["didUserAnswered"],
        lastCallTime: json["lastCallTime"],
        notes: json["notes"],
        priority: json["priority"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "leadProvider": leadProvider?.toJson(),
        "clientName": clientName,
        "vehicle": vehicle,
        "phoneNumber": phoneNumber,
        "city": city,
        "isFinanceInterested": isFinanceInterested,
        "interested": interested,
        "time": time?.toIso8601String(),
        "updated": updated,
        "expectedEarnings": expectedEarnings,
        "partnersTake": partnersTake,
        "leadNote": leadNote,
        "noteForPrt": noteForPrt,
        "takePaid": takePaid,
        "txnID": txnId,
        "leadClosedOn": leadClosedOn,
        "deleted": deleted,
        "paymentStatus": paymentStatus,
        "status": status,
        "didAdminCalled": didAdminCalled,
        "didUserAnswered": didUserAnswered,
        "lastCallTime": lastCallTime,
        "notes": notes,
        "priority": priority,
      };
}

class LeadProvider {
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

  LeadProvider({
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

  factory LeadProvider.fromJson(Map<String, dynamic> json) => LeadProvider(
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
