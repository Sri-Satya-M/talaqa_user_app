class SessionPayment {
  int? id;
  int? sessionId;
  int? totalAmount;
  int? clinicianCommision;
  int? clinicianAmount;
  int? alsanAmount;
  bool? paymentStatus;
  DateTime? createdAt;
  DateTime? updatedAt;

  SessionPayment({
    this.id,
    this.sessionId,
    this.totalAmount,
    this.clinicianCommision,
    this.clinicianAmount,
    this.alsanAmount,
    this.paymentStatus,
    this.createdAt,
    this.updatedAt,
  });

  factory SessionPayment.fromJson(Map<String, dynamic> json) => SessionPayment(
    id: json["id"],
    sessionId: json["sessionId"],
    totalAmount: json["totalAmount"],
    clinicianCommision: json["clinicianCommision"],
    clinicianAmount: json["clinicianAmount"],
    alsanAmount: json["alsanAmount"],
    paymentStatus: json["paymentStatus"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "sessionId": sessionId,
    "totalAmount": totalAmount,
    "clinicianCommision": clinicianCommision,
    "clinicianAmount": clinicianAmount,
    "alsanAmount": alsanAmount,
    "paymentStatus": paymentStatus,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}