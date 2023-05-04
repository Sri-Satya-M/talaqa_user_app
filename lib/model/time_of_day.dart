class TimeOfDay {
  TimeOfDay({
    this.label,
    this.slots,
  });

  String? label;
  List<TimeSlot>? slots;

  factory TimeOfDay.fromJson(Map<String, dynamic> json) => TimeOfDay(
        label: json["label"],
        slots:
            List<TimeSlot>.from(json["slots"].map((x) => TimeSlot.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "slots": List<dynamic>.from(slots?.map((x) => x.toJson()) ?? []),
      };
}

class SessionTimeslot {
  int? id;
  int? sessionId;
  int? timeslotId;
  int? clinicianId;
  DateTime? date;
  DateTime? createdAt;
  DateTime? updatedAt;
  TimeSlot? timeslot;

  SessionTimeslot({
    this.id,
    this.sessionId,
    this.timeslotId,
    this.clinicianId,
    this.date,
    this.createdAt,
    this.updatedAt,
    this.timeslot,
  });

  factory SessionTimeslot.fromJson(Map<String, dynamic> json) => SessionTimeslot(
    id: json["id"],
    sessionId: json["sessionId"],
    timeslotId: json["timeslotId"],
    clinicianId: json["clinicianId"],
    date: DateTime.parse(json["date"]),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    timeslot: TimeSlot.fromJson(json["timeslot"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "sessionId": sessionId,
    "timeslotId": timeslotId,
    "clinicianId": clinicianId,
    "date": "${date?.year.toString().padLeft(4, '0')}-${date?.month.toString().padLeft(2, '0')}-${date?.day.toString().padLeft(2, '0')}",
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "timeslot": timeslot?.toJson(),
  };
}

class TimeSlot {
  int? id;
  String? label;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? endAt;
  String? startAt;
  String? day;

  TimeSlot({
    this.id,
    this.label,
    this.createdAt,
    this.updatedAt,
    this.endAt,
    this.startAt,
    this.day,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) => TimeSlot(
    id: json["id"],
    label: json["label"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    endAt: json["endAt"],
    startAt: json["startAt"],
    day: json["day"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "label": label,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "endAt": endAt,
    "startAt": startAt,
    "day": day,
  };
}
