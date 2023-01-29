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

  String formatAddress(Address address) {
    String formattedAddress = '';
    formattedAddress +=
    address.addressLine1 == null ? '' : '${address.addressLine1!}, ';
    formattedAddress +=
    address.addressLine2 == null ? '' : '${address.addressLine2!}, ';
    formattedAddress += address.city == null ? '' : '${address.city!}, ';
    formattedAddress += address.country == null ? '' : '${address.country!}, ';
    formattedAddress += address.pincode == null ? '' : '${address.pincode!}, ';
    return formattedAddress;
  }
}
