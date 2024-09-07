import 'package:json_annotation/json_annotation.dart';

part 'hours_worked.g.dart';

@JsonSerializable()
class HoursWorked {
  final String dateAdded;
  final String addedBy;
  final double hoursCompleted;
  final String documentName;
  final bool isCompleted;
  final String assignedUser;
  final String documentUrl;

  HoursWorked({
    required this.dateAdded,
    required this.addedBy,
    required this.hoursCompleted,
    required this.documentName,
    required this.isCompleted,
    required this.assignedUser,
    required this.documentUrl,
  });

  factory HoursWorked.fromJson(Map<String, dynamic> json) =>
      _$HoursWorkedFromJson(json);

  Map<String, dynamic> toJson() => _$HoursWorkedToJson(this);
}
