class Profile {
  Profile({
    this.id,
    this.image,
    this.age,
    this.gender,
    this.city,
    this.country,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  int? id;
  String? image;
  int? age;
  String? gender;
  String? city;
  dynamic country;
  int? userId;
  DateTime? createdAt;
  DateTime? updatedAt;
  User? user;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    id: json["id"],
    image: json["image"],
    age: json["age"],
    gender: json["gender"],
    city: json["city"],
    country: json["country"],
    userId: json["userId"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "image": image,
    "age": age,
    "gender": gender,
    "city": city,
    "country": country,
    "userId": userId,
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
