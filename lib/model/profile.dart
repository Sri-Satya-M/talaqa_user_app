import 'user.dart';

class Profile {
  Profile({
    this.id,
    this.fullName,
    this.image,
    this.age,
    this.gender,
    this.city,
    this.country,
    this.pincode,
    this.userId,
    this.patientId,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  int? id;
  String? fullName;
  String? image;
  int? age;
  String? gender;
  String? city;
  String? country;
  int? pincode;
  int? userId;
  int? patientId;
  DateTime? createdAt;
  DateTime? updatedAt;
  User? user;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    id: json["id"],
    fullName: json["fullName"],
    image: json["image"],
    age: json["age"],
    gender: json["gender"],
    city: json["city"],
    country: json["country"],
    userId: json["userId"],
    pincode: json["pincode"],
    patientId: json["patientId"],
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
    "city": city,
    "country": country,
    "userId": userId,
    "patientId": patientId,
    "pincode": pincode,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "user": user?.toJson(),
  };
}

