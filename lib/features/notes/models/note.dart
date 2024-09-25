import 'comment.dart';

class Note {
  String noteID;
  String title;
  String description;
  String content;
  String email;
  String addedBy;
  String? editedBy;
  DateTime dateAdded;
  List<Comment> comments;

  Note({
    required this.noteID,
    required this.title,
    required this.description,
    required this.email,
    required this.content,
    this.editedBy,
    required this.addedBy,
    required this.dateAdded,
    this.comments = const [],
  });

  Map<String, dynamic> toJson() => {
    'noteID': noteID,
    'title': title,
    'description': description,
    'email': email,
    'content': content,
    'addedBy': addedBy,
    'editedBy': editedBy,
    'dateAdded': dateAdded.toIso8601String(),
    'comments': comments.map((comment) => comment.toJson()).toList(),
  };

  factory Note.fromJson(Map<String, dynamic> json) => Note(
    noteID: json['noteID'],
    title: json['title'],
    description: json['description'],
    email: json['email'],
    editedBy: json['editedBy'] ?? '',
    content: json['content'],
    addedBy: json['addedBy'],
    dateAdded: DateTime.parse(json['dateAdded']),
    comments: (json['comments'] as List<dynamic>)
        .map((comment) => Comment.fromJson(comment))
        .toList(),
  );

  Note copyWith({
    String? noteID,
    String? title,
    String? description,
    String? content,
    String? email,
    String? addedBy,
    String? editedBy,
    DateTime? dateAdded,
    List<Comment>? comments,
  }) {
    return Note(
      noteID: noteID ?? this.noteID,
      title: title ?? this.title,
      description: description ?? this.description,
      content: content ?? this.content,
      email: email ?? this.email,
      addedBy: addedBy ?? this.addedBy,
      editedBy: editedBy ?? this.editedBy,
      dateAdded: dateAdded ?? this.dateAdded,
      comments: comments ?? this.comments,
    );
  }
}
