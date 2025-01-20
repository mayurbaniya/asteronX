class LeaderBoardModel {
  String? leadsSentThisMonth;
  String? totalEarningsThisMonth;
  String? leadsClosedSuccessfully;
  String? failedLeads;
  String? totalLeadsSent;
  String? totalEarnings;

  LeaderBoardModel({
    this.leadsSentThisMonth,
    this.totalEarningsThisMonth,
    this.leadsClosedSuccessfully,
    this.failedLeads,
    this.totalLeadsSent,
    this.totalEarnings,
  });

  factory LeaderBoardModel.fromJson(Map<String, dynamic> json) =>
      LeaderBoardModel(
        leadsSentThisMonth: json["leadsSentThisMonth"],
        totalEarningsThisMonth: json["totalEarningsThisMonth"],
        leadsClosedSuccessfully: json["leadsClosedSuccessfully"],
        failedLeads: json["failedLeads"],
        totalLeadsSent: json["totalLeadsSent"],
        totalEarnings: json["totalEarnings"],
      );

  Map<String, dynamic> toJson() => {
        "leadsSentThisMonth": leadsSentThisMonth,
        "totalEarningsThisMonth": totalEarningsThisMonth,
        "leadsClosedSuccessfully": leadsClosedSuccessfully,
        "failedLeads": failedLeads,
        "totalLeadsSent": totalLeadsSent,
        "totalEarnings": totalEarnings,
      };

  // Utility getters
  double get leadsSentThisMonthDouble =>
      double.tryParse(leadsSentThisMonth ?? '0') ?? 0.0;
  double get totalEarningsThisMonthDouble =>
      double.tryParse(totalEarningsThisMonth ?? '0') ?? 0.0;
  double get leadsClosedSuccessfullyDouble =>
      double.tryParse(leadsClosedSuccessfully ?? '0') ?? 0.0;
  double get failedLeadsDouble => double.tryParse(failedLeads ?? '0') ?? 0.0;
  double get totalLeadsSentDouble =>
      double.tryParse(totalLeadsSent ?? '0') ?? 0.0;
  double get totalEarningsDouble =>
      double.tryParse(totalEarnings ?? '0') ?? 0.0;
}
