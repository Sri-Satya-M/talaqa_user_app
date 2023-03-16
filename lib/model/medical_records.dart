class MedicalRecord {
  MedicalRecord({
    this.id,
    this.patientId,
    this.key,
    this.createdAt,
    this.updatedAt,
    this.fileUrl,
  });

  int? id;
  int? patientId;
  String? key;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? fileUrl;

  factory MedicalRecord.fromJson(Map<String, dynamic> json) => MedicalRecord(
    id: json["id"],
    patientId: json["patientId"],
    key: json["key"],
    createdAt: json["createdAt"]==null? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"]==null? null : DateTime.parse(json["updatedAt"]),
    fileUrl: json["fileUrl"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "patientId": patientId,
    "key": key,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "fileUrl": fileUrl,
  };
}
