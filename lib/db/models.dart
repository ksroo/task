import 'dart:convert';

import '../mock/userMock.dart';
import 'package:http/http.dart' as http;

class ModelUser {
  String uid;
  String fullName;
  String firstName;
  String lastName;
  String email;
  String city;
  String stateProvince;
  String country;
  String postalCode;
  String photoUrl;
  bool online;
  String lastTimeOnline;
  String venues;
  String preferredComps;
  String gender;
  String pickImage;



  static List<ModelUser> _users = mock_users;

  ModelUser(
      {this.uid = "",
      this.fullName = "",
      this.firstName = "",
      this.lastName = "",
      this.email = "",
      this.city = "",
      this.stateProvince = "",
      this.country = "",
      this.postalCode = "",
      this.photoUrl = "",
      this.venues = "",
      this.preferredComps = "",
      this.gender = ""});

  static ModelUser lookupUserByEmail(String email) {
    var i = _users.indexWhere((user) => user.email == email);
    if (i >= 0) return _users[i];
    return ModelUser();
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'fullName': fullName,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'city': city,
        'stateProvince': stateProvince,
        'country': country,
        'postalCode': postalCode,
        'photoUrl': photoUrl,
        'venues': venues,
        'preferredComps': preferredComps,
        'gender': gender
      };

  ModelUser fromJson() {
    return ModelUser();
  }

  @override
  String toString() {
    return '''
      uid: $uid
      fullName: $fullName,
      firstName: $firstName,
      lastName: $lastName,
      email: $email,
      city: $city,
      stateProvince: $stateProvince,
      country: $country,
      postalCode: $postalCode,
      photoUrl: $photoUrl,
      venues: $venues,
      preferredComps: $preferredComps,
      gender: $gender
      ''';
  }
}
