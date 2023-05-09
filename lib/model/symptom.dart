class Symptom {
  int? id;
  String? title;
  DateTime? createdAt;
  DateTime? updatedAt;

  Symptom({
    this.id,
    this.title,
    this.createdAt,
    this.updatedAt,
  });

  factory Symptom.fromJson(Map<String, dynamic> json) => Symptom(
    id: json["id"]==null? null : json["id"],
    title: json["title"]==null? null : json["title"],
    createdAt: json["createdAt"]==null? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"]==null? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}