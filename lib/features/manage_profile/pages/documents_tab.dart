import 'package:alpha/features/documents/models/document.dart';
import 'package:alpha/features/manage_profile/models/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../custom_widgets/cards/document_card.dart';

class DocumentsTab extends StatefulWidget {
  final List<Document> documents;
  final UserProfile profile;
  final WidgetRef ref;
  const DocumentsTab({super.key, required this.documents, required this.profile, required this.ref});

  @override
  State<DocumentsTab> createState() => _DocumentsTabState();
}

class _DocumentsTabState extends State<DocumentsTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: widget.documents.length,
        itemBuilder: (context, index) {
          final document = widget.documents[index];
          return DocumentCard(
            document: document,
            profile: widget.profile,
            ref: widget.ref,
          );
        },
      ),
    );
  }
}
