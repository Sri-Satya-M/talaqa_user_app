import '../utils/helper.dart';

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

class TimeSlot {
  TimeSlot({
    this.id,
    this.clinicianId,
    this.timeSlotId,
    this.startAt,
    this.endAt,
    this.status,
    this.day,
    this.createdAt,
    this.updatedAt,
    this.label,
  });

  int? id;
  int? clinicianId;
  int? timeSlotId;
  String? startAt;
  String? endAt;
  bool? status;
  String? day;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? label;

  factory TimeSlot.fromJson(Map<String, dynamic> json) => TimeSlot(
        id: json["id"],
        clinicianId: json["clinicianId"],
        timeSlotId: json["timeSlotId"],
        startAt: json["startAt"],
        endAt: json["endAt"],
        status: json["status"],
        day: json["day"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        label: json["label"],
      );

  Map<String, dynamic> toJson() => {
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
      obj: (json) => TimeSlot.fromJson(json),
    ).map((e) => e as TimeSlot).toList();
  }
}
