import '../../hours_worked/models/document.dart';

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
  int hoursWorked;
  bool visible;
  bool done;
  String notes;
  List<Document>? documents;

  Shift(
      {required this.shiftId,
      required this.placeName,
      required this.startTime,
      required this.endTime,
      required this.duration,
      required this.hoursWorked,
      required this.date,
      required this.visible,
      required this.dateAdded,
      required this.addedBy,
      required this.contactPersonNumber,
      required this.contactPersonAltNumber,
      required this.staffEmail,
      required this.done,
      required this.notes,
      this.documents});

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
        'visible': visible,
        'documents': documents?.map((doc) => doc.toJson()).toList(),
        'hoursWorked': hoursWorked
      };

  factory Shift.fromJson(Map<String, dynamic> json) => Shift(
        shiftId: json['shiftId'] ?? '',
        placeName: json['placeName'] ?? '',
        startTime: json['startTime'] ?? '',
        hoursWorked: json['hoursWorked'] ?? 0,
        endTime: json['endTime'] ?? '',
        duration: json['duration'] ?? '',
        date: json['day'] ?? '',
        visible: json['visible'] ?? true,
        dateAdded: json['dateAdded'] ?? '',
        addedBy: json['addedBy'] ?? '',
        contactPersonNumber: json['contactPersonNumber'] ?? '',
        contactPersonAltNumber: json['contactPersonAltNumber'] ?? '',
        staffEmail: json['staffEmail'] ?? '',
        done: json['done'] ?? '',
        notes: json['notes'] ?? '',
        documents: (json['documents'] as List?)
            ?.map((doc) => Document.fromJson(doc))
            .toList(),
      );

  Shift copyWith({
    String? shiftId,
    String? placeName,
    String? startTime,
    String? endTime,
    String? duration,
    String? date,
    String? dateAdded,
    String? addedBy,
    String? contactPersonNumber,
    String? contactPersonAltNumber,
    String? staffEmail,
    bool? done,
    bool? visible,
    String? notes,
    List<Document>? documents,
    int? hoursWorked,
  }) {
    return Shift(
      shiftId: shiftId ?? this.shiftId,
      placeName: placeName ?? this.placeName,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      duration: duration ?? this.duration,
      date: date ?? this.date,
      dateAdded: dateAdded ?? this.dateAdded,
      addedBy: addedBy ?? this.addedBy,
      contactPersonNumber: contactPersonNumber ?? this.contactPersonNumber,
      contactPersonAltNumber:
          contactPersonAltNumber ?? this.contactPersonAltNumber,
      staffEmail: staffEmail ?? this.staffEmail,
      done: done ?? this.done,
      notes: notes ?? this.notes,
      documents: documents ?? this.documents,
      visible: visible ?? this.visible,
      hoursWorked: hoursWorked ?? this.hoursWorked
    );
  }
}
