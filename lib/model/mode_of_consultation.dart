class ModeOfConsultation {
  ModeOfConsultation({
    this.id,
    this.type,
    this.imageUrl,
    this.title,
    this.price,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? type;
  String? imageUrl;
  String? title;
  int? price;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory ModeOfConsultation.fromMap(Map<String, dynamic> json) =>
      ModeOfConsultation(
        id: json["id"],
        type: json["type"],
        imageUrl: json["imageUrl"],
        title: json["title"],
        price: json["price"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "type": type,
        "imageUrl": imageUrl,
        "title": title,
        "price": price,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
