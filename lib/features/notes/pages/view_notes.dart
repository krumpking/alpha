import 'package:alpha/core/constants/dimensions.dart';
import 'package:alpha/features/manage_profile/models/user_profile.dart';
import 'package:alpha/features/notes/models/note.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/color_constants.dart';
import '../../../custom_widgets/custom_button/general_button.dart';
import '../../../custom_widgets/text_fields/custom_text_field.dart';
import '../helper/notes_helper.dart';
class ViewNotesScreen extends StatefulWidget {
  final Note note;
  final UserProfile selectedUser;

  const ViewNotesScreen({
    super.key,
    required this.selectedUser,
    required this.note,
  });

  @override
  State<ViewNotesScreen> createState() => _ViewNotesScreenState();
}

class _ViewNotesScreenState extends State<ViewNotesScreen> {
  final TextEditingController _commentController = TextEditingController();
  User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.primaryColor,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.selectedUser.name!,
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildNoteDetails(),
            const SizedBox(height: 20),
            _buildCommentsSection(),
            const SizedBox(height: 12),
            _buildCommentInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteDetails() {
    return Container(
      width: Dimensions.screenWidth,
      padding: const EdgeInsets.all(20),
      margin:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.white,
            offset: Offset(-5, -5),
            blurRadius: 10,
          ),
          BoxShadow(
            color: Colors.black12,
            offset: Offset(5, 5),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Title',
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.note.title,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Description',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                widget.note.description,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Comment',
                style: TextStyle(fontSize: 14),
              ),

              Text(
                widget.note.content,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsSection() {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.note.comments.length,
        itemBuilder: (context, index) {
          final comment = widget.note.comments[index];
          return ListTile(
            title: Text(comment.addedBy, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
            subtitle: Text(comment.description, style: const TextStyle(fontSize: 10,),),
            trailing: Text(
              '${comment.dateAdded.toLocal()}'.split(' ')[0],
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCommentInput() {
    return Row(
      children: [
        Expanded(
          child: CustomTextField(
            controller: _commentController,
            labelText: 'Add a comment',
            prefixIcon: const Icon(Icons.comment, color: Colors.grey),
          ),
        ),
        const SizedBox(width: 8),
        GeneralButton(
          width: 100,
          borderRadius: 10,
          onTap: (){
            NotesHelper.addComment(note: widget.note, comment: _commentController.text, user: currentUser!);
            _commentController.clear();
            setState(() {

            });
          },
          btnColor: Pallete.primaryColor,
          child: const Text(
            'Submit',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
