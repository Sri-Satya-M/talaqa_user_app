class Report {
  Report({
    this.id,
    this.sessionId,
    this.status,
    this.type,
    this.url,
    this.data,
    this.createdAt,
    this.updatedAt,
    this.fileUrl,
  });

  int? id;
  int? sessionId;
  String? status;
  String? type;
  String? url;
  Data? data;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? fileUrl;

  factory Report.fromJson(Map<String, dynamic> json) => Report(
    id: json["id"]==null? null: json["id"],
    sessionId: json["sessionId"]==null? null: json["sessionId"],
    status: json["status"]==null? null: json["status"],
    type: json["type"]==null? null: json["type"],
    url: json["url"]==null? null: json["url"],
    data: json["data"]==null? null: Data.fromJson(json["data"]),
    createdAt: DateTime.parse(json["createdAt"])==null? null: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"])==null? null: DateTime.parse(json["updatedAt"]),
    fileUrl: json["fileUrl"]==null? null: json["fileUrl"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "sessionId": sessionId,
    "status": status,
    "type": type,
    "url": url,
    "data": data?.toJson(),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "fileUrl": fileUrl,
  };
}

class Data {
  Data({
    this.date,
    this.comments,
    this.generalImpression,
    this.previousDiagnosis,
  });

  DateTime? date;
  String? comments;
  String? generalImpression;
  String? previousDiagnosis;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    date: DateTime.parse(json["date"]),
    comments: json["comments"],
    generalImpression: json["generalImpression"],
    previousDiagnosis: json["previousDiagnosis"],
  );

  Map<String, dynamic> toJson() => {
    "date": "${date?.year.toString().padLeft(4, '0')}-${date?.month.toString().padLeft(2, '0')}-${date?.day.toString().padLeft(2, '0')}",
    "comments": comments,
    "generalImpression": generalImpression,
    "previousDiagnosis": previousDiagnosis,
  };
}
