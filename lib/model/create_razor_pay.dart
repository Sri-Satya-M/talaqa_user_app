class CreateRazorPay {
  CreateRazorPay({
    this.id,
    this.sessionId,
    this.rzpOrderId,
    this.rzpPaymentId,
    this.rzpSignature,
    this.rzpOrderAmount,
    this.paymentStatus,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? sessionId;
  String? rzpOrderId;
  dynamic? rzpPaymentId;
  dynamic? rzpSignature;
  int? rzpOrderAmount;
  bool? paymentStatus;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory CreateRazorPay.fromJson(Map<String, dynamic> json) => CreateRazorPay(
    id: json["id"],
    sessionId: json["sessionId"],
    rzpOrderId: json["rzpOrderId"],
    rzpPaymentId: json["rzpPaymentId"],
    rzpSignature: json["rzpSignature"],
    rzpOrderAmount: json["rzpOrderAmount"],
    paymentStatus: json["paymentStatus"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "sessionId": sessionId,
    "rzpOrderId": rzpOrderId,
    "rzpPaymentId": rzpPaymentId,
    "rzpSignature": rzpSignature,
    "rzpOrderAmount": rzpOrderAmount,
    "paymentStatus": paymentStatus,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}
