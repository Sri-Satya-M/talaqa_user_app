class Patient {
  Patient({
    this.id,
    this.image,
    this.age,
    this.gender,
    this.city,
    this.country,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.fullName,
    this.patientId,
  });

  int? id;
  String? image;
  int? age;
  String? gender;
  String? city;
  String? country;
  int? userId;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? fullName;
  int? patientId;

  factory Patient.fromMap(Map<String, dynamic> json) => Patient(
    id: json["id"],
    image: json["image"],
    age: json["age"],
    gender: json["gender"],
    city: json["city"],
    country: json["country"],
    userId: json["userId"],
    fullName: json["fullName"],
    patientId: json["patientId"],
    updatedAt: json["updatedAt"] == null? null: DateTime.parse(json["updatedAt"]),
    createdAt: json["createdAt"] == null? null: DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "image": image,
    "age": age,
    "gender": gender,
    "city": city,
    "country": country,
    "userId": userId,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "fullName": fullName,
    "patientId": patientId,
  };
}