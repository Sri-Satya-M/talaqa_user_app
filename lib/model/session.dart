import 'package:alsan_app/model/profile.dart';
import 'package:alsan_app/model/time_of_day.dart';

import 'address.dart';
import 'clinicians.dart';

class Session {
  Session({
    this.id,
    this.sessionId,
    this.clinicianTimeSlotIds,
    this.date,
    this.day,
    this.description,
    this.consultationMode,
    this.consultationFee,
    this.totalAmount,
    this.patientId,
    this.patientProfileId,
    this.patientAddressId,
    this.clinicianId,
    this.status,
    this.otp,
    this.reportDocument,
    this.createdAt,
    this.updatedAt,
    this.patient,
    this.patientProfile,
    this.patientAddress,
    this.clinician,
    this.sessionStatuses,
    this.clinicianTimeSlots,
  });

  int? id;
  String? sessionId;
  List<String>? clinicianTimeSlotIds;
  DateTime? date;
  String? day;
  String? description;
  String? consultationMode;
  int? consultationFee;
  int? totalAmount;
  int? patientId;
  int? patientProfileId;
  int? patientAddressId;
  int? clinicianId;
  String? status;
  int? otp;
  String? reportDocument;
  DateTime? createdAt;
  DateTime? updatedAt;
  Profile? patient;
  Profile? patientProfile;
  Address? patientAddress;
  Clinician? clinician;
  List<SessionStatus>? sessionStatuses;
  List<TimeSlot>? clinicianTimeSlots;

  factory Session.fromMap(Map<String, dynamic> json) => Session(
        id: json["id"],
        sessionId: json["sessionId"],
        clinicianTimeSlotIds: json["clinicianSlotIds"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        day: json["day"],
        description: json["description"],
        consultationMode: json["consultationMode"],
        consultationFee: json["consultationFee"],
        totalAmount: json["totalAmount"],
        patientId: json["patientId"],
        patientProfileId: json["patientProfileId"],
        patientAddressId: json["patientAddressId"],
        clinicianId: json["clinicianId"],
        status: json["status"],
        otp: json["otp"],
        reportDocument: json["reportDocument"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        patient: Profile.fromJson(json["patient"]),
        patientProfile: Profile.fromJson(json["patientProfile"]),
        patientAddress: json["patientAddress"] == null
            ? null
            : Address.fromMap(json["patientAddress"]),
        clinician: Clinician.fromMap(json["clinician"]),
        sessionStatuses: json["sessionStatuses"] == null
            ? []
            : List<SessionStatus>.from(json["sessionStatuses"]
                    ?.map((x) => SessionStatus.fromJson(x)) ??
                []),
        clinicianTimeSlots: List<TimeSlot>.from(
            json["clinicianTimeSlots"]?.map((x) => TimeSlot.fromMap(x)) ?? []),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "sessionId": sessionId,
        "clinicianTimeSlotIds": clinicianTimeSlotIds,
        "date":
            "${date?.year.toString().padLeft(4, '0')}-${date?.month.toString().padLeft(2, '0')}-${date?.day.toString().padLeft(2, '0')}",
        "day": day,
        "description": description,
        "consultationMode": consultationMode,
        "consultationFee": consultationFee,
        "totalAmount": totalAmount,
        "patientId": patientId,
        "patientProfileId": patientProfileId,
        "patientAddressId": patientAddressId,
        "clinicianId": clinicianId,
        "status": status,
        "otp": otp,
        "reportDocument": reportDocument,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "patient": patient?.toJson(),
        "patientProfile": patientProfile?.toJson(),
        "patientAddress": patientAddress?.toMap(),
        "clinician": clinician?.toMap(),
        "clinicianTimeSlots":
            List<dynamic>.from(clinicianTimeSlots?.map((x) => x.toMap()) ?? []),
        "sessionStatuses":
            List<dynamic>.from(sessionStatuses?.map((x) => x.toJson()) ?? []),
      };
}

class SessionStatus {
  SessionStatus({
    this.id,
    this.sessionId,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? sessionId;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory SessionStatus.fromJson(Map<String, dynamic> json) => SessionStatus(
        id: json["id"],
        sessionId: json["sessionId"],
        status: json["status"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sessionId": sessionId,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
