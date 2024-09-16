// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feedback_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedbackModel _$FeedbackModelFromJson(Map<String, dynamic> json) =>
    FeedbackModel(
      date: json['date'] as String,
      addedBy: json['addedBy'] as String,
      feedbackTitle: json['feedbackTitle'] as String,
      description: json['description'] as String,
      feedbackSource: json['feedbackSource'] as String,
      userEmail: json['userEmail'] as String,
    );

Map<String, dynamic> _$FeedbackModelToJson(FeedbackModel instance) =>
    <String, dynamic>{
      'date': instance.date,
      'addedBy': instance.addedBy,
      'feedbackTitle': instance.feedbackTitle,
      'feedbackSource': instance.feedbackSource,
      'description': instance.description,
      'userEmail': instance.userEmail,
    };
