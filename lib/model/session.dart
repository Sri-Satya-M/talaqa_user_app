import 'package:alsan_app/model/profile.dart';
import 'package:alsan_app/model/time_of_day.dart';

import 'address.dart';
import 'clinicians.dart';
import 'duration_time.dart';
import 'session_payment.dart';

class Session {
  Session(
      {
      this.id,
      this.sessionId,
      this.clinicianTimeSlotIds,
      this.date,
      this.day,
      this.description,
      this.consultationMode,
      this.patientId,
      this.patientProfileId,
      this.patientAddressId,
      this.clinicianId,
      this.status,
      this.duration,
      this.otp,
      this.reportDocument,
      this.createdAt,
      this.updatedAt,
      this.patient,
      this.patientProfile,
      this.patientAddress,
      this.clinician,
      this.sessionStatuses,
      this.sessionTimeslots,
      this.sessionClinician,
      this.sessionPayment,
      this.type,
      this.startAt,
      this.endAt,
      });

  int? id;
  String? sessionId;
  List<String>? clinicianTimeSlotIds;
  DateTime? date;
  String? day;
  String? description;
  String? consultationMode;
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
  String? type;
  String? startAt;
  String? endAt;
  List<DurationTime>? duration;
  List<SessionStatus>? sessionStatuses;
  List<SessionTimeslot>? sessionTimeslots;
  SessionClinician? sessionClinician;
  SessionPayment? sessionPayment;

  factory Session.fromMap(Map<String, dynamic> json) => Session(
      id: json["id"],
      sessionId: json["sessionId"],
      sessionTimeslots: List<SessionTimeslot>.from(json["sessionTimeslots"].map((x) => SessionTimeslot.fromJson(x))),
      date: json["date"] == null ? null : DateTime.parse(json["date"]),
      description: json["description"],
      consultationMode: json["consultationMode"],
      patientId: json["patientId"],
      patientProfileId: json["patientProfileId"],
      patientAddressId: json["patientAddressId"],
      clinicianId: json["clinicianId"],
      status: json["status"],
      duration: List<DurationTime>.from(
          json["duration"].map((x) => DurationTime.fromJson(x))),
      otp: json["otp"],
      reportDocument: json["reportDocument"],
      createdAt:
          json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
      updatedAt:
          json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      patient: Profile.fromJson(json["patient"]),
      patientProfile: Profile.fromJson(json["patientProfile"]),
      patientAddress: json["patientAddress"] == null
          ? null
          : Address.fromMap(json["patientAddress"]),
      clinician: Clinician.fromMap(json["clinician"]),
      sessionPayment: SessionPayment.fromJson(json["sessionPayment"]),
      sessionStatuses: json["sessionStatuses"] == null
          ? []
          : List<SessionStatus>.from(
              json["sessionStatuses"]?.map((x) => SessionStatus.fromJson(x)) ??
                  []),
      sessionClinician : json['sessionClinician']==null ? null: SessionClinician.fromJson(json['sessionClinician']),
      type: json["type"],
      startAt: json["startAt"] == null ? null: json["startAt"],
      endAt: json["endAt"] == null ? null: json["endAt"],
  );

  Map<String, dynamic> toMap() => {
        "id": id,
        "sessionId": sessionId,
        "sessionTimeslots": sessionTimeslots,
        "date":
            "${date?.year.toString().padLeft(4, '0')}-${date?.month.toString().padLeft(2, '0')}-${date?.day.toString().padLeft(2, '0')}",
        "day": day,
        "description": description,
        "consultationMode": consultationMode,
        "totalAmount": totalAmount,
        "patientId": patientId,
        "patientProfileId": patientProfileId,
        "patientAddressId": patientAddressId,
        "clinicianId": clinicianId,
        "status": status,
        "duration": List<dynamic>.from(duration?.map((x) => x.toJson()) ?? []),
        "otp": otp,
        "reportDocument": reportDocument,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "patient": patient?.toJson(),
        "patientProfile": patientProfile?.toJson(),
        "patientAddress": patientAddress?.toMap(),
        "clinician": clinician?.toMap(),
        "sessionTimeslots": List<dynamic>.from(
            sessionTimeslots?.map((x) => x.toJson()) ?? []),
        "sessionStatuses":
            List<dynamic>.from(sessionStatuses?.map((x) => x.toJson()) ?? []),
        "sessionPayment": sessionPayment?.toJson(),
        "type": type,
        "startAt": startAt,
        "endAt": endAt,
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

class SessionClinician {
  SessionClinician({
    this.id,
    this.sessionId,
    this.clinicianId,
    this.newClinicianId,
    this.isNewClinicianAccepted,
    this.isPatientAccepted,
    this.clinician,
    this.newClinician,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? sessionId;
  int? clinicianId;
  int? newClinicianId;
  bool? isNewClinicianAccepted;
  bool? isPatientAccepted;
  Clinician? clinician;
  Clinician? newClinician;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory SessionClinician.fromJson(Map<String, dynamic> json) => SessionClinician(
    id: json["id"],
    sessionId: json["sessionId"],
    clinicianId: json["clinicianId"],
    newClinicianId: json["newClinicianId"],
    isNewClinicianAccepted: json["isNewClinicianAccepted"],
    isPatientAccepted: json["isPatientAccepted"],
    clinician: json["clinician"]==null? null : Clinician.fromMap(json["clinician"]),
    newClinician: json["newClinician"]==null? null : Clinician.fromMap(json["newClinician"]),
    createdAt: json["createdAt"] == null ? json["createdAt"] : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? json["updatedAt"] : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "sessionId": sessionId,
    "clinicianId": clinicianId,
    "newClinicianId": newClinicianId,
    "isNewClinicianAccepted": isNewClinicianAccepted,
    "isPatientAccepted": isPatientAccepted,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}
