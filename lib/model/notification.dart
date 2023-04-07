class Notification {
  Notification({
    this.body,
    this.type,
    this.title,
    this.status,
    this.typeId,
  });

  String? body;
  String? type;
  String? title;
  String? status;
  String? typeId;

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
    body: json["body"],
    type: json["type"],
    title: json["title"],
    status: json["status"],
    typeId: json["typeId"],
  );

  Map<String, dynamic> toJson() => {
    "body": body,
    "type": type,
    "title": title,
    "status": status,
    "typeId": typeId,
  };
}