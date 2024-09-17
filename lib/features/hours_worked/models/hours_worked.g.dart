// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hours_worked.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HoursWorked _$HoursWorkedFromJson(Map<String, dynamic> json) => HoursWorked(
      dateAdded: json['dateAdded'] as String,
      addedBy: json['addedBy'] as String,
      hoursCompleted: (json['hoursCompleted'] as num).toDouble(),
      documentName: json['documentName'] as String,
      isCompleted: json['isCompleted'] as bool,
      assignedUser: json['assignedUser'] as String,
      documentUrl: json['documentUrl'] as String,
    );

Map<String, dynamic> _$HoursWorkedToJson(HoursWorked instance) =>
    <String, dynamic>{
      'dateAdded': instance.dateAdded,
      'addedBy': instance.addedBy,
      'hoursCompleted': instance.hoursCompleted,
      'documentName': instance.documentName,
      'isCompleted': instance.isCompleted,
      'assignedUser': instance.assignedUser,
      'documentUrl': instance.documentUrl,
    };
