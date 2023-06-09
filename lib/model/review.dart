import 'package:alsan_app/model/profile.dart';

class Review {
  Review({
    this.id,
    this.sessionId,
    this.clinicianId,
    this.patientId,
    this.rating,
    this.comment,
    this.createdAt,
    this.updatedAt,
    this.patient,
  });

  num? id;
  num? sessionId;
  num? clinicianId;
  num? patientId;
  num? rating;
  String? comment;
  DateTime? createdAt;
  DateTime? updatedAt;
  Profile? patient;

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json["id"],
        sessionId: json["sessionId"],
        clinicianId: json["clinicianId"],
        patientId: json["patientId"],
        rating: json["rating"],
        comment: json["comment"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        patient: Profile.fromJson(json["patient"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sessionId": sessionId,
        "clinicianId": clinicianId,
        "patientId": patientId,
        "rating": rating,
        "comment": comment,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "patient": patient?.toJson(),
      };
}
