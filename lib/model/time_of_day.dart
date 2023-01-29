import '../utils/helper.dart';

class TimeOfDay {
  TimeOfDay({
    this.morning,
    this.afternoon,
    this.evening,
    this.night,
  });

  List<TimeSlot>? morning;
  List<TimeSlot>? afternoon;
  List<TimeSlot>? evening;
  List<TimeSlot>? night;

  factory TimeOfDay.fromMap(Map<String, dynamic> json) => TimeOfDay(
    morning: json["MORNING"] == null ? null: List<TimeSlot>.from(json["MORNING"].map((x) => TimeSlot.fromMap(x))),
    afternoon: json["AFTERNOON"] == null ? null: List<TimeSlot>.from(json["AFTERNOON"].map((x) => TimeSlot.fromMap(x))),
    evening: json["EVENING"] == null ? null: List<TimeSlot>.from(json["EVENING"].map((x) => TimeSlot.fromMap(x))),
    night: json["NIGHT"] == null ? null: List<TimeSlot>.from(json["NIGHT"].map((x) => TimeSlot.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "MORNING": List<dynamic>.from(morning?.map((x) => x.toMap()) ?? []),
    "AFTERNOON": List<dynamic>.from(afternoon?.map((x) => x.toMap()) ?? []),
    "EVENING": List<dynamic>.from(evening?.map((x) => x.toMap()) ?? []),
    "NIGHT": List<dynamic>.from(night?.map((x) => x.toMap()) ?? []),
  };
}

class TimeSlot {
  TimeSlot({
    this.id,
    this.clinicianId,
    this.timeSlotId,
    this.startAt,
    this.endAt,
    this.status,
    this.day,
    this.label,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? clinicianId;
  int? timeSlotId;
  String? startAt;
  String? endAt;
  bool? status;
  String? day;
  String? label;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory TimeSlot.fromMap(Map<String, dynamic> json) => TimeSlot(
    id: json["id"],
    clinicianId: json["clinicianId"],
    timeSlotId: json["timeSlotId"],
    startAt: json["startAt"],
    endAt: json["endAt"],
    status: json["status"],
    day: json["day"],
    label: json["label"],
    createdAt: json["createdAt"]==null ? null: DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"]==null ? null: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "clinicianId": clinicianId,
    "timeSlotId": timeSlotId,
    "startAt": startAt,
    "endAt": endAt,
    "status": status,
    "day": day,
    "label": label,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };

  List<TimeSlot> showTimeslots(dynamic collection) {
    return Helper.sortByKey(
      collection: collection.map((c) => c.toMap()).toList(),
      key: 'startAt',
      obj: (json) => TimeSlot.fromMap(json),
    ).map((e) => e as TimeSlot).toList();
  }
}
