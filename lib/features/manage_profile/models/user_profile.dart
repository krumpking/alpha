import 'package:alpha/features/shift/models/shift.dart';

import '../../documents/models/document.dart';

class UserProfile {
  String? name;
  String? email;
  String? phoneNumber;
  String? address;
  String? previousEmployer;
  String? contactInformation;
  String? role;
  List<String> specialisations;
  String? profilePicture;
  String? city;
  String? state;
  String? country;
  String? post;
  List<Document> documents;
  DateTime? dob;
  String? gender;

  UserProfile({
    required this.name,
    required this.email,
    required this.city,
    required this.phoneNumber,
    required this.address,
    this.profilePicture,
    required this.country,
    required this.state,
    required this.previousEmployer,
    required this.contactInformation,
    required this.role,
    required this.post,
    required this.specialisations,
    required this.documents,
    required this.dob,
    required this.gender,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'phoneNumber': phoneNumber,
        'address': address,
        'previousEmployer': previousEmployer,
        'contactInformation': contactInformation,
        'role': role,
        'post': post,
        'specialisations': specialisations,
        'profilePicture': profilePicture,
        'documents': documents.map((document) => document.toJson()).toList(),
        'dob': dob?.toIso8601String(),
        'gender': gender,
        'city': city,
        'state': state,
        'country': country
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        phoneNumber: json['phoneNumber'] ?? '',
        address: json['address'] ?? '',
        previousEmployer: json['previousEmployer'] ?? '',
        contactInformation: json['contactInformation'] ?? '',
        role: json['role'] ?? '',
        post: json['post'] ?? '',
        specialisations: List<String>.from(json['specialisations']),
        profilePicture: json['profilePicture'] ?? '',
        documents: (json['documents'] as List)
            .map((documentJson) => Document.fromJson(documentJson))
            .toList(),
        dob: json['dob'] != null ? DateTime.parse(json['dob']) : null,
        gender: json['gender'] ?? '',
        city: json['city'] ?? '',
        state: json['state'] ?? '',
        country: json['country'] ?? '',
      );

  UserProfile copyWith({
    String? name,
    String? email,
    String? phoneNumber,
    String? address,
    List<Shift>? preferredWorkDays,
    String? previousEmployer,
    String? contactInformation,
    String? role,
    List<String>? specialisations,
    String? profilePicture,
    String? city,
    String? state,
    String? country,
    String? post,
    List<Document>? documents,
    DateTime? dob,
    String? gender,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      previousEmployer: previousEmployer ?? this.previousEmployer,
      contactInformation: contactInformation ?? this.contactInformation,
      role: role ?? this.role,
      specialisations: specialisations ?? this.specialisations,
      profilePicture: profilePicture ?? this.profilePicture,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      post: post ?? this.post,
      documents: documents ?? this.documents,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
    );
  }
}
