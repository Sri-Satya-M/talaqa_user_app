class Symptom {
  int? id;
  String? title;
  String? arabic;
  DateTime? createdAt;
  DateTime? updatedAt;

  Symptom({
    this.id,
    this.title,
    this.arabic,
    this.createdAt,
    this.updatedAt,
  });

  factory Symptom.fromJson(Map<String, dynamic> json) => Symptom(
    id: json["id"]==null? null : json["id"],
    title: json["title"]==null? null : json["title"],
    arabic: json["arabic"]==null? null : json["arabic"],
    createdAt: json["createdAt"]==null? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"]==null? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "arabic": arabic,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}