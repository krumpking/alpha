// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feedback_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedbackModel _$FeedbackModelFromJson(Map<String, dynamic> json) =>
    FeedbackModel(
      date: json['date'] as String,
      addedBy: json['addedBy'] as String,
      feedackTitle: json['feedackTitle'] as String,
      description: json['description'] as String,
      userEmail: json['userEmail'] as String,
    );

Map<String, dynamic> _$FeedbackModelToJson(FeedbackModel instance) =>
    <String, dynamic>{
      'date': instance.date,
      'addedBy': instance.addedBy,
      'feedackTitle': instance.feedackTitle,
      'description': instance.description,
      'userEmail': instance.userEmail,
    };
