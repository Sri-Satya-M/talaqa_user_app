import 'package:alsan_app/model/symptom.dart';

class Services {
  int count;
  List<Service> services;

  Services({
    required this.count,
    required this.services,
  });

  factory Services.fromJson(Map<String, dynamic> json) => Services(
    count: json["count"],
    services: List<Service>.from(json["services"].map((x) => Service.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "services": List<dynamic>.from(services.map((x) => x.toJson())),
  };
}

class Service {
  int? id;
  String? title;
  String? arabicTitle;
  String? description;
  String? arabicDescription;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<Symptom>? symptoms;

  Service({
    this.id,
    this.title,
    this.arabicTitle,
    this.description,
    this.arabicDescription,
    this.createdAt,
    this.updatedAt,
    this.symptoms,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    id: json["id"] == null? null: json["id"],
    title: json["title"] == null? null: json["title"],
    arabicTitle: json["arabicTitle"] == null? null: json["arabicTitle"],
    description: json["description"] == null? null: json["description"],
    arabicDescription: json["arabicDescription"] == null? null: json["arabicDescription"],
    createdAt: json["createdAt"] == null? null: DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null? null: DateTime.parse(json["updatedAt"]),
    symptoms: json["symptoms"] == null? null: List<Symptom>.from(json["symptoms"].map((x) => Symptom.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "arabicTitle": arabicTitle,
    "description": description,
    "arabicDescription": arabicDescription,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "symptoms": List<dynamic>.from(symptoms?.map((x) => x.toJson())??[]),
  };
}
