
class UserProfile {
  String name;
  String email;
  String phoneNumber;
  String address;
  DateTime? preferredWorkDays;
  String previousEmployer;
  String contactInformation;
  String role;
  List<String> specialisations;
  String? profilePicture;
  String? documentUrl;
  String documentName;
  DateTime? expiryDate;
  DateTime? dob;
  String? gender;
  String city;
  String post;

  UserProfile({
    required this.name,
    required this.email,
    required this.city,
    required this.phoneNumber,
    required this.address,
    this.preferredWorkDays,
    this.profilePicture,
    required this.previousEmployer,
    required this.contactInformation,
    required this.role,
    required this.post,
    required this.specialisations,
    this.documentUrl,
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
    'role': role,
    'post': post,
    'specialisations': specialisations,
    'profilePicture': profilePicture,
    'documentUrl': documentUrl,
    'documentName': documentName,
    'expiryDate': expiryDate?.toIso8601String(),
    'dob': dob?.toIso8601String(),
    'gender': gender,
    'city' : city
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
    role: json['role'],
    post: json['post'],
    specialisations: List<String>.from(json['specialisations']),
    profilePicture: json['profilePicture'],
    documentUrl: json['documentUrl'],
    documentName: json['documentName'],
    city: 'city',
    expiryDate: json['expiryDate'] != null
        ? DateTime.parse(json['expiryDate'])
        : null,
    dob: json['dob'] != null ? DateTime.parse(json['dob']) : null,
    gender: json['gender'],
  );
}
