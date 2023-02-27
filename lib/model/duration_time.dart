class DurationTime {
  DurationTime({
    this.id,
    this.sessionId,
    this.duration,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? sessionId;
  int? duration;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory DurationTime.fromJson(Map<String, dynamic> json) => DurationTime(
    id: json["id"],
    sessionId: json["sessionId"],
    duration: json["duration"],
    createdAt: json["createdAt"] == null? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "sessionId": sessionId,
    "duration": duration,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}
