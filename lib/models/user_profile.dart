import 'dart:io';

class UserProfile {
  String name;
  String email;
  String phoneNumber;
  String address;
  DateTime? preferredWorkDays;
  String previousEmployer;
  String contactInformation;
  String currentRole;
  List<String> specialisations;
  String? profilePicture;
  File? document;
  String documentName;
  DateTime? expiryDate;
  DateTime? dob;
  String? gender;

  UserProfile({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.address,
    this.preferredWorkDays,
    this.profilePicture,
    required this.previousEmployer,
    required this.contactInformation,
    required this.currentRole,
    required this.specialisations,
    this.document,
    required this.documentName,
    this.expiryDate,
    required this.dob,
    required this.gender,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'phoneNumber': phoneNumber,
    'address': address,
    'preferredWorkDays': preferredWorkDays?.toIso8601String(),
    'previousEmployer': previousEmployer,
    'contactInformation': contactInformation,
    'currentRole': currentRole,
    'specialisations': specialisations,
    'profilePicture': profilePicture,
    'document': document?.path,
    'documentName': documentName,
    'expiryDate': expiryDate?.toIso8601String(),
    'dob': dob?.toIso8601String(),
    'gender': gender,
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    name: json['name'],
    email: json['email'],
    phoneNumber: json['phoneNumber'],
    address: json['address'],
    preferredWorkDays: json['preferredWorkDays'] != null
        ? DateTime.parse(json['preferredWorkDays'])
        : null,
    previousEmployer: json['previousEmployer'],
    contactInformation: json['contactInformation'],
    currentRole: json['currentRole'],
    specialisations: List<String>.from(json['specialisations']),
    profilePicture: json['profilePicture'],
    document: json['document'] != null ? File(json['document']) : null,
    documentName: json['documentName'],
    expiryDate: json['expiryDate'] != null
        ? DateTime.parse(json['expiryDate'])
        : null,
    dob: json['dob'] != null ? DateTime.parse(json['dob']) : null,
    gender: json['gender'],
  );
}
