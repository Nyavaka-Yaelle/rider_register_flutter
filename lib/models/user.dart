class User {
  String? displayName, firstName, lastName;
  String? phoneNumber;
  String? password;
  String? email;
  bool? isRider;
  String? profilePicture;

  User.empty();

  User({
    this.displayName = "",
    this.firstName = "",
    this.lastName = "",
    this.password = "",
    this.phoneNumber = "",
    this.email = "",
    this.isRider = false,
    this.profilePicture = "",
  });

  User.fromJson(Map<String, dynamic> json) {
    displayName = json['displayName']?.toString();
    firstName = json['firstName']?.toString();
    lastName = json['lastName']?.toString();
    password = json['password']?.toString();
    phoneNumber = json['phoneNumber']?.toString();
    email = json['email']?.toString();
    isRider = json['isRider']?.toString() == 'true';
    profilePicture = json['profilePicture']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['displayName'] = displayName;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['password'] = password;
    data['phoneNumber'] = phoneNumber;
    data['email'] = email;
    data['isRider'] = isRider;
    data['profilePicture'] = profilePicture;
    return data;
  }
}

class Rider {
  String? displayName;
  String? phoneNumber;
  String? password;
  String? email;
  bool? isRider;
  String? profilePicture;
  String? vehicleLicencePlate;
  String? vehicleType;

  double? moyenneNote; // New property for average note
  int?
      nombreLivraisonsArrived; // New property for the number of "Arrived" deliveries
Rider.empty();
  Rider({
    this.displayName = "",
    this.password = "",
    this.phoneNumber = "",
    this.email = "",
    this.isRider = false,
    this.profilePicture,
    this.vehicleLicencePlate = "",
    this.vehicleType = "",
    this.moyenneNote,
    this.nombreLivraisonsArrived,
  });

  factory Rider.fromJson(Map<String, dynamic> json) {
    return Rider(
      displayName: json['displayName']?.toString(),
      password: json['password']?.toString(),
      phoneNumber: json['phoneNumber']?.toString(),
      email: json['email']?.toString(),
      isRider: json['isRider']?.toString() == 'true',
      profilePicture: json['profilePicture']?.toString(),
      vehicleLicencePlate: json['vehicleLicencePlate']?.toString(),
      vehicleType: json['vehicleType']?.toString(),
      moyenneNote: json['moyenneNote']?.toDouble(),
      nombreLivraisonsArrived: json['nombreLivraisonsArrived'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName,
      'password': password,
      'phoneNumber': phoneNumber,
      'email': email,
      'isRider': isRider,
      'profilePicture': profilePicture,
      'vehicleLicencePlate': vehicleLicencePlate,
      'moyenneNote': moyenneNote,
      'vehicleType': vehicleType,
      'nombreLivraisonsArrived': nombreLivraisonsArrived,
    };
  }
}
