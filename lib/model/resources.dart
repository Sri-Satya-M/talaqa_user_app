class Resources {
  Resources({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnail,
    required this.link,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String title;
  String description;
  String thumbnail;
  String link;
  String type;
  DateTime createdAt;
  DateTime updatedAt;

  factory Resources.fromJson(Map<String, dynamic> json) => Resources(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    thumbnail: json["thumbnail"],
    link: json["link"],
    type: json["type"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "thumbnail": thumbnail,
    "link": link,
    "type": type,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}
