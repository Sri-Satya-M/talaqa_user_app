import 'user.dart';

class Clinician {
  Clinician({
    this.id,
    this.imageUrl,
    this.alternateEmail,
    this.alternateMobileNumber,
    this.dob,
    this.gender,
    this.bio,
    this.license,
    this.location,
    this.experience,
    this.userId,
    this.designation,
    this.languagesKnown,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  int? id;
  String? imageUrl;
  String? alternateEmail;
  String? alternateMobileNumber;
  DateTime? dob;
  String? gender;
  String? bio;
  String? license;
  String? location;
  int? experience;
  int? userId;
  String? designation;
  String? languagesKnown;
  DateTime? createdAt;
  DateTime? updatedAt;
  User? user;

  factory Clinician.fromMap(Map<String, dynamic> json) => Clinician(
    id: json["id"],
    imageUrl: json["imageUrl"],
    alternateEmail: json["alternateEmail"],
    alternateMobileNumber: json["alternateMobileNumber"],
    dob: DateTime.parse(json["dob"]),
    gender: json["gender"],
    bio: json["bio"],
    license: json["license"],
    location: json["location"],
    experience: json["experience"],
    userId: json["userId"],
    designation: json["designation"],
    languagesKnown: json["languagesKnown"],
    createdAt: json["createdAt"] == null? null: DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null? null: DateTime.parse(json["updatedAt"]),
    user: json["user"]== null? null: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "imageUrl": imageUrl,
    "alternateEmail": alternateEmail,
    "alternateMobileNumber": alternateMobileNumber,
    "dob": dob?.toIso8601String(),
    "gender": gender,
    "bio": bio,
    "license": license,
    "location": location,
    "experience": experience,
    "userId": userId,
    "designation": designation,
    "languagesKnown": languagesKnown,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "user": user?.toJson(),
  };
}
