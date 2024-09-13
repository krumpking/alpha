class Shift {
  String shiftId;
  String placeName;
  String startTime;
  String endTime;
  String duration;
  String date;
  String dateAdded;
  String addedBy;
  String contactPersonNumber;
  String contactPersonAltNumber;
  String staffEmail;
  bool done;
  String notes;

  Shift({
    required this.shiftId,
    required this.placeName,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.date,
    required this.dateAdded,
    required this.addedBy,
    required this.contactPersonNumber,
    required this.contactPersonAltNumber,
    required this.staffEmail,
    required this.done,
    required this.notes,
  });

  Map<String, dynamic> toJson() => {
    'shiftId': shiftId,
    'placeName': placeName,
    'startTime': startTime,
    'endTime': endTime,
    'duration': duration,
    'day': date,
    'dateAdded': dateAdded,
    'addedBy': addedBy,
    'contactPersonNumber': contactPersonNumber,
    'contactPersonAltNumber': contactPersonAltNumber,
    'staffEmail': staffEmail,
    'done': done,
    'notes': notes,
  };

  factory Shift.fromJson(Map<String, dynamic> json) => Shift(
    shiftId: json['shiftId'] ?? '',
    placeName: json['placeName'] ?? '',
    startTime: json['startTime'] ?? '',
    endTime: json['endTime'] ?? '',
    duration: json['duration'] ?? '',
    date: json['day'] ?? '',
    dateAdded: json['dateAdded'] ?? '',
    addedBy: json['addedBy'] ?? '',
    contactPersonNumber: json['contactPersonNumber'] ?? '',
    contactPersonAltNumber: json['contactPersonAltNumber'] ?? '',
    staffEmail: json['staffEmail'] ?? '',
    done: json['done'] ?? '',
    notes: json['notes'] ?? '',
  );

}

