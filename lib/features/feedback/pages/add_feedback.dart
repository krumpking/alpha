import 'package:alpha/core/utils/logs.dart';
import 'package:alpha/core/utils/routes.dart';
import 'package:alpha/features/feedback/helpers/helpers.dart';
import 'package:alpha/global/global.dart';
import 'package:alpha/models/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import '../../../core/constants/color_constants.dart';
import '../../../custom_widgets/custom_button/general_button.dart';
import '../../../custom_widgets/custom_switch/custom_switch.dart';
import '../../../custom_widgets/text_fields/custom_text_field.dart';
import 'package:get/get.dart';

class AddFeedbackScreen extends StatefulWidget {
  final UserProfile selectedUser;
  final String shiftId;

  const AddFeedbackScreen(
      {super.key, required this.selectedUser, required this.shiftId});

  @override
  State<AddFeedbackScreen> createState() => _AddFeedbackScreenState();
}

class _AddFeedbackScreenState extends State<AddFeedbackScreen> {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController feedbackTitleController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser;
  FeedbackTag? feedbackTag;
  bool _isAlpha = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Container(
              width: 150,
              height: 150,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Pallete.primaryColor,
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.feedback,
                size: 100,
                color: Pallete.primaryColor,
              ),
            ),
            Text(
              'Add Feedback',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Pallete.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            const SizedBox(
              height: 24,
            ),
            CustomTextField(
              keyBoardType: TextInputType.text,
              controller: feedbackTitleController,
              labelText: 'Title',
              prefixIcon: const Icon(Icons.description, color: Colors.grey),
            ),
            const SizedBox(
              height: 12,
            ),
            CustomTextField(
              controller: descriptionController,
              labelText: 'Description',
              prefixIcon: const Icon(Icons.description, color: Colors.grey),
            ),
            const SizedBox(
              height: 12,
            ),
            Center(
              child: GeneralButton(
                onTap: () => {
                  FeedbackHelper.validateAndSubmitFeedback(
                    description: descriptionController.text.trim(),
                    currentUser: currentUser!,
                    feedbackTitle: feedbackTitleController.text.trim(),
                    selectedUser: widget.selectedUser,
                    shiftId: widget.shiftId,
                  )
                },
                borderRadius: 10,
                btnColor: Pallete.primaryColor,
                width: 300,
                child: const Text(
                  "Add Feedback",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
