// To parse this JSON data, do
//
//     final feedback = feedbackFromJson(jsonString);

import 'dart:convert';

import 'package:alsan_app/model/profile.dart';

List<Feedback> feedbackFromJson(String str) => List<Feedback>.from(json.decode(str).map((x) => Feedback.fromJson(x)));

String feedbackToJson(List<Feedback> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Feedback {
  Feedback({
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

  int? id;
  int? sessionId;
  int? clinicianId;
  int? patientId;
  int? rating;
  String? comment;
  DateTime? createdAt;
  DateTime? updatedAt;
  Profile? patient;

  factory Feedback.fromJson(Map<String, dynamic> json) => Feedback(
    id: json["id"],
    sessionId: json["sessionId"],
    clinicianId: json["clinicianId"],
    patientId: json["patientId"],
    rating: json["rating"],
    comment: json["comment"],
    createdAt: json["createdAt"]==null? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"]==null? null : DateTime.parse(json["updatedAt"]),
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
