import 'package:alpha/models/document.dart';
import 'package:flutter/material.dart';
import '../../../custom_widgets/cards/document_card.dart';
import '../../../custom_widgets/cards/task_item.dart';

class DocumentsTab extends StatefulWidget {
  final List<Document> documents;
  const DocumentsTab({super.key, required this.documents});

  @override
  State<DocumentsTab> createState() => _DocumentsTabState();
}

class _DocumentsTabState extends State<DocumentsTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: widget.documents.length, // Specify the number of items
        itemBuilder: (context, index) {
          // Fetch the document at the current index
          final document = widget.documents[index];

          // Use the document's data to populate the TaskItemCard
          return DocumentCard(
            document: document,
          );
        },
      ),
    );
  }
}
