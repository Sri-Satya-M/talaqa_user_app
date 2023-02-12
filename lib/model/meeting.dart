class Meeting {
  Meeting({
    this.id,
    this.meetingId,
    this.sessionId,
    this.clinicianId,
    this.clinicianToken,
    this.patientId,
    this.patientProfileId,
    this.patientProfileToken,
    this.date,
    this.startAt,
    this.endAt,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? meetingId;
  int? sessionId;
  int? clinicianId;
  String? clinicianToken;
  int? patientId;
  int? patientProfileId;
  String? patientProfileToken;
  DateTime? date;
  String? startAt;
  String? endAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Meeting.fromJson(Map<String, dynamic> json) => Meeting(
    id: json["id"],
    meetingId: json["meetingId"],
    sessionId: json["sessionId"],
    clinicianId: json["clinicianId"],
    clinicianToken: json["clinicianToken"],
    patientId: json["patientId"],
    patientProfileId: json["patientProfileId"],
    patientProfileToken: json["patientProfileToken"],
    date: DateTime.parse(json["date"]),
    startAt: json["startAt"],
    endAt: json["endAt"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "meetingId": meetingId,
    "sessionId": sessionId,
    "clinicianId": clinicianId,
    "clinicianToken": clinicianToken,
    "patientId": patientId,
    "patientProfileId": patientProfileId,
    "patientProfileToken": patientProfileToken,
    "date": "${date?.year.toString().padLeft(4, '0')}-${date?.month.toString().padLeft(2, '0')}-${date?.day.toString().padLeft(2, '0')}",
    "startAt": startAt,
    "endAt": endAt,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}
