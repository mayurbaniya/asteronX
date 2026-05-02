// Lead list / detail model. Backed by the new LeadResponse / LeadPageResponse
// DTOs on the backend (post V1__cleanup_external_leads_and_exchange.sql).
//
// Schema changes vs. the old shape this client was written for:
//   * `notes` -> `partnerSubmittedNote`
//   * `noteForPrt` -> `noteVisibleToPartner`
//   * `leadNote` is admin-only and not exposed in the response
//   * `isFinanceInterested` -> `financeInterest` (enum: YES / NO / UNSURE)
//   * `priority` is now an enum string (LOW / MEDIUM / HIGH), not int
//   * `status` enum: NEW / IN_PROGRESS / CLOSED / CANCELLED (was ONGOING / DELETED)
//   * money fields are JSON numbers now, decoded as `num`
//   * top-level `time` removed; use `created`
//   * `deleted` flag removed (status == CANCELLED replaces it)
//   * `takePaid` int -> `takePaidAmount` numeric

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
  int? leadProviderID;
  String? leadProviderName;
  String? clientName;
  String? vehicle;
  String? phoneNumber;
  String? altPhoneNumber;
  String? city;

  /// "YES" / "NO" / "UNSURE"
  String? financeInterest;

  /// "NEW" / "IN_PROGRESS" / "CLOSED" / "CANCELLED"
  String? status;

  /// "LOW" / "MEDIUM" / "HIGH"
  String? priority;

  /// "PENDING" / "PAID" / "FAILED"
  String? paymentStatus;

  bool? interested;
  DateTime? nextFollowUp;
  DateTime? lastCallTime;
  DateTime? leadClosedOn;

  num? expectedEarnings;
  num? partnersTake;
  num? earned;
  num? takePaidAmount;
  String? txnId;

  String? partnerSubmittedNote;
  String? noteVisibleToPartner;

  DateTime? created;
  DateTime? updated;

  Content({
    this.id,
    this.leadProviderID,
    this.leadProviderName,
    this.clientName,
    this.vehicle,
    this.phoneNumber,
    this.altPhoneNumber,
    this.city,
    this.financeInterest,
    this.status,
    this.priority,
    this.paymentStatus,
    this.interested,
    this.nextFollowUp,
    this.lastCallTime,
    this.leadClosedOn,
    this.expectedEarnings,
    this.partnersTake,
    this.earned,
    this.takePaidAmount,
    this.txnId,
    this.partnerSubmittedNote,
    this.noteVisibleToPartner,
    this.created,
    this.updated,
  });

  /// Convenience: server stores partner provider as flat fields in the
  /// new response, but UI code wants a `LeadProvider` object. Build one
  /// on demand for callers that still want it.
  LeadProvider? get leadProvider => leadProviderID == null
      ? null
      : LeadProvider(id: leadProviderID, name: leadProviderName);

  static DateTime? _parseDate(dynamic raw) {
    if (raw == null) return null;
    if (raw is String && raw.isEmpty) return null;
    return DateTime.tryParse(raw.toString());
  }

  static num? _parseNum(dynamic raw) {
    if (raw == null) return null;
    if (raw is num) return raw;
    return num.tryParse(raw.toString());
  }

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        id: json["id"],
        leadProviderID: json["leadProviderID"],
        leadProviderName: json["leadProviderName"],
        clientName: json["clientName"],
        vehicle: json["vehicle"],
        phoneNumber: json["phoneNumber"],
        altPhoneNumber: json["altPhoneNumber"],
        city: json["city"],
        financeInterest: json["financeInterest"],
        status: json["status"],
        priority: json["priority"],
        paymentStatus: json["paymentStatus"],
        interested: json["interested"],
        nextFollowUp: _parseDate(json["nextFollowUp"]),
        lastCallTime: _parseDate(json["lastCallTime"]),
        leadClosedOn: _parseDate(json["leadClosedOn"]),
        expectedEarnings: _parseNum(json["expectedEarnings"]),
        partnersTake: _parseNum(json["partnersTake"]),
        earned: _parseNum(json["earned"]),
        takePaidAmount: _parseNum(json["takePaidAmount"]),
        txnId: json["txnID"],
        partnerSubmittedNote: json["partnerSubmittedNote"],
        noteVisibleToPartner: json["noteVisibleToPartner"],
        created: _parseDate(json["created"]),
        updated: _parseDate(json["updated"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "leadProviderID": leadProviderID,
        "leadProviderName": leadProviderName,
        "clientName": clientName,
        "vehicle": vehicle,
        "phoneNumber": phoneNumber,
        "altPhoneNumber": altPhoneNumber,
        "city": city,
        "financeInterest": financeInterest,
        "status": status,
        "priority": priority,
        "paymentStatus": paymentStatus,
        "interested": interested,
        "nextFollowUp": nextFollowUp?.toIso8601String(),
        "lastCallTime": lastCallTime?.toIso8601String(),
        "leadClosedOn": leadClosedOn?.toIso8601String(),
        "expectedEarnings": expectedEarnings,
        "partnersTake": partnersTake,
        "earned": earned,
        "takePaidAmount": takePaidAmount,
        "txnID": txnId,
        "partnerSubmittedNote": partnerSubmittedNote,
        "noteVisibleToPartner": noteVisibleToPartner,
        "created": created?.toIso8601String(),
        "updated": updated?.toIso8601String(),
      };
}

/// Slim partner-provider projection. The LeadResponse now ships flat
/// `leadProviderID` + `leadProviderName`, but legacy UI still references
/// `lead.leadProvider?.name` so we expose the same shape via getter.
class LeadProvider {
  int? id;
  String? name;

  LeadProvider({this.id, this.name});

  factory LeadProvider.fromJson(Map<String, dynamic> json) => LeadProvider(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
