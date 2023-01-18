class Clinicians {
  Clinicians({
    this.id,
    this.image,
    this.alternateEmail,
    this.alternateMobileNumber,
    this.dob,
    this.gender,
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
  String? image;
  dynamic alternateEmail;
  dynamic alternateMobileNumber;
  DateTime? dob;
  String? gender;
  String? location;
  int? experience;
  int? userId;
  dynamic designation;
  dynamic languagesKnown;
  DateTime? createdAt;
  DateTime? updatedAt;
  User? user;

  factory Clinicians.fromJson(Map<String, dynamic> json) => Clinicians(
    id: json["id"],
    image: json["image"],
    alternateEmail: json["alternateEmail"],
    alternateMobileNumber: json["alternateMobileNumber"],
    dob: DateTime.parse(json["dob"]),
    gender: json["gender"],
    location: json["location"],
    experience: json["experience"],
    userId: json["userId"],
    designation: json["designation"],
    languagesKnown: json["languagesKnown"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "image": image,
    "alternateEmail": alternateEmail,
    "alternateMobileNumber": alternateMobileNumber,
    "dob": dob?.toIso8601String(),
    "gender": gender,
    "location": location,
    "experience": experience,
    "userId": userId,
    "designation": designation,
    "languagesKnown": languagesKnown,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "user": user!.toJson(),
  };
}

class User {
  User({
    this.id,
    this.fullName,
    this.email,
    this.mobileNumber,
    this.password,
    this.userType,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? fullName;
  String? email;
  String? mobileNumber;
  String? password;
  String? userType;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    fullName: json["fullName"],
    email: json["email"],
    mobileNumber: json["mobileNumber"],
    password: json["password"],
    userType: json["UserType"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "fullName": fullName,
    "email": email,
    "mobileNumber": mobileNumber,
    "password": password,
    "UserType": userType,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}
