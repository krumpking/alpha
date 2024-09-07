import 'package:alpha/models/document.dart';
import 'package:flutter/material.dart';

class NotesTab extends StatefulWidget {
  final List<Document> notes;
  const NotesTab({super.key, required this.notes});

  @override
  State<NotesTab> createState() => _NotesTabState();
}

class _NotesTabState extends State<NotesTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}
