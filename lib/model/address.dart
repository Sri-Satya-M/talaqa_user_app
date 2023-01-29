class Address {
  Address({
    this.id,
    this.latitude,
    this.longitude,
    this.addressLine1,
    this.addressLine2,
    this.landmark,
    this.pincode,
    this.city,
    this.country,
    this.mobileNumber,
    this.patientId,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? latitude;
  String? longitude;
  String? addressLine1;
  String? addressLine2;
  String? landmark;
  String? pincode;
  String? city;
  String? country;
  String? mobileNumber;
  int? patientId;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Address.fromMap(Map<String, dynamic> json) => Address(
        id: json["id"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        addressLine1: json["addressLine1"],
        addressLine2: json["addressLine2"],
        landmark: json["landmark"],
        pincode: json["pincode"],
        city: json["city"],
        country: json["country"],
        mobileNumber: json["mobileNumber"],
        patientId: json["patientId"],
        createdAt: json["createdAt"] == null? null: DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null? null: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "latitude": latitude,
        "longitude": longitude,
        "addressLine1": addressLine1,
        "addressLine2": addressLine2,
        "landmark": landmark,
        "pincode": pincode,
        "city": city,
        "country": country,
        "mobileNumber": mobileNumber,
        "patientId": patientId,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
