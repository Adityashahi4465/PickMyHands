// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  String name;
  final String email;
  String phoneNumber;
  String dob;
  String gender;
  String disability;
  String profilePicture;
  String disabilityCerti;
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.dob,
    required this.gender,
    required this.disability,
    required this.profilePicture,
    required this.disabilityCerti,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    String? dob,
    String? gender,
    String? disability,
    String? profilePicture,
    String? disabilityCerti,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      disability: disability ?? this.disability,
      profilePicture: profilePicture ?? this.profilePicture,
      disabilityCerti: disabilityCerti ?? this.disabilityCerti,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'dob': dob,
      'gender': gender,
      'disability': disability,
      'profilePicture': profilePicture,
      'disabilityCerti': disabilityCerti,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      phoneNumber: map['phoneNumber'] as String,
      dob: map['dob'] as String,
      gender: map['gender'] as String,
      disability: map['disability'] as String,
      profilePicture: map['profilePicture'] as String,
      disabilityCerti: map['disabilityCerti'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, phoneNumber: $phoneNumber, dob: $dob, gender: $gender, disability: $disability, profilePicture: $profilePicture, disabilityCerti: $disabilityCerti)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.email == email &&
        other.phoneNumber == phoneNumber &&
        other.dob == dob &&
        other.gender == gender &&
        other.disability == disability &&
        other.profilePicture == profilePicture &&
        other.disabilityCerti == disabilityCerti;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        phoneNumber.hashCode ^
        dob.hashCode ^
        gender.hashCode ^
        disability.hashCode ^
        profilePicture.hashCode ^
        disabilityCerti.hashCode;
  }
}
