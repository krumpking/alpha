import 'package:json_annotation/json_annotation.dart';

part 'feedback_model.g.dart';

@JsonSerializable()
class FeedbackModel {
  final String date;
  final String addedBy;
  final String feedackTitle;
  final String description;
  final String userEmail;

  FeedbackModel({
    required this.date,
    required this.addedBy,
    required this.feedackTitle,
    required this.description,
    required this.userEmail,
  });

  // Add fromJson and toJson methods
  factory FeedbackModel.fromJson(Map<String, dynamic> json) =>
      _$FeedbackModelFromJson(json);

  Map<String, dynamic> toJson() => _$FeedbackModelToJson(this);
}
