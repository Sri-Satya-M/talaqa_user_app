import 'package:alsan_app/model/medical_records.dart';

import 'user.dart';

class Profile {
  Profile({
    this.id,
    this.fullName,
    this.image,
    this.age,
    this.gender,
    this.dob,
    this.city,
    this.country,
    this.pincode,
    this.userId,
    this.patientId,
    this.patientProfile,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.medicalRecords,
  });

  int? id;
  String? fullName;
  String? image;
  int? age;
  String? gender;
  String? dob;
  String? city;
  String? country;
  int? pincode;
  int? userId;
  int? patientId;
  Profile? patientProfile;
  DateTime? createdAt;
  DateTime? updatedAt;
  User? user;
  List<MedicalRecord>? medicalRecords;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    id: json["id"],
    fullName: json["fullName"],
    image: json["image"],
    age: json["age"],
    gender: json["gender"],
    dob: json["dob"],
    city: json["city"],
    country: json["country"],
    userId: json["userId"],
    pincode: json["pincode"],
    patientId: json["patientId"],
    medicalRecords: json["medicalRecords"] == null ? null : List<MedicalRecord>.from(json["medicalRecords"].map((m) => MedicalRecord.fromJson(m))),
    patientProfile: json["PatientProfile"] == null ? null :Profile.fromJson(json["PatientProfile"]),
    createdAt: json["createdAt"]==null ? null: DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"]==null ? null: DateTime.parse(json["updatedAt"]),
    user: json["user"] == null ? null: User?.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "fullName": fullName,
    "image": image,
    "age": age,
    "gender": gender,
    "dob": dob,
    "city": city,
    "country": country,
    "userId": userId,
    "patientId": patientId,
    "PatientProfile": patientProfile,
    "pincode": pincode,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "user": user?.toJson(),
    "medicalRecords": medicalRecords?.map((m) => m.toJson()),
  };
}

