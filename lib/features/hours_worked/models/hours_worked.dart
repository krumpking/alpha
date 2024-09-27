import '../../documents/models/document.dart';

class HoursWorked {
  String id;
  String staffEmail;
  double hoursWorked;
  DateTime dateAdded;
  String addedBy;
  List<Document> documents;

  HoursWorked({
    required this.id,
    required this.staffEmail,
    required this.hoursWorked,
    required this.dateAdded,
    required this.addedBy,
    required this.documents,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'staffEmail': staffEmail,
      'hoursWorked': hoursWorked,
      'dateAdded': dateAdded.toIso8601String(),
      'addedBy': addedBy,
      'documents': documents.map((doc) => doc.toJson()).toList(),
    };
  }

  factory HoursWorked.fromJson(Map<String, dynamic> json) {
    return HoursWorked(
      id: json['id'],
      staffEmail: json['staffEmail'],
      hoursWorked: (json['hoursWorked'] as num).toDouble(),
      dateAdded: DateTime.parse(json['dateAdded']),
      addedBy: json['addedBy'],
      documents: (json['documents'] as List)
          .map((doc) => Document.fromJson(doc as Map<String, dynamic>))
          .toList(),
    );
  }
}
