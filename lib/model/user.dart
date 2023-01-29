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

  factory User.fromMap(Map<String, dynamic> json) => User(
    id: json["id"],
    fullName: json["fullName"],
    email: json["email"],
    mobileNumber: json["mobileNumber"],
    password: json["password"],
    userType: json["UserType"],
    createdAt: json["createdAt"] == null? null: DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null? null: DateTime.parse(json["updatedAt"]),
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