import 'package:alpha/features/workers/helper/storage_helper.dart';
import 'package:alpha/models/document.dart';
import 'package:alpha/models/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/color_constants.dart';
import '../../../custom_widgets/custom_button/general_button.dart';
import '../../../custom_widgets/custom_switch/custom_switch.dart';
import '../../../custom_widgets/text_fields/custom_text_field.dart';
import '../../../models/shift.dart';
import '../helpers/shift_helpers.dart';

class EditShift extends StatefulWidget {
  final UserProfile selectedUser;
  final Shift shift;
  const EditShift({super.key, required this.selectedUser, required this.shift});

  @override
  State<EditShift> createState() => _EditShiftState();
}

class _EditShiftState extends State<EditShift> {
  final TextEditingController _documentNameController = TextEditingController();
  final TextEditingController _hoursWorkedController = TextEditingController();
  bool _isCompleted = false;
  User? currentUser;
  List<Document> documents = [];
  String selectedDocumentUrl = "";

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    _isCompleted = widget.shift.done;
    documents = widget.shift.documents ?? [];

    setState(() {
      _hoursWorkedController.text = widget.shift.duration;
    });
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
            _buildHeader(),
            const SizedBox(height: 24),
            _buildDocumentUpload(),
            const SizedBox(height: 12),
            CustomTextField(
              controller: _hoursWorkedController,
              labelText: 'Hours Worked',
              prefixIcon: const Icon(Icons.description, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            const SizedBox(height: 12),
            _buildCompletionSwitch(),
            const SizedBox(height: 20),
            _buildUpdateButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 150,
          height: 150,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Pallete.primaryColor, width: 2),
          ),
          child: Icon(
            Icons.calendar_month,
            size: 100,
            color: Pallete.primaryColor,
          ),
        ),
        Text(
          'Edit Shift',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Pallete.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildDocumentUpload() {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: CustomTextField(
            controller: _documentNameController,
            labelText: 'Document Name',
            prefixIcon: const Icon(Icons.description, color: Colors.grey),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: GeneralButton(
            onTap: () async {
              await StorageHelper.triggerDocUpload(_documentNameController.text)
                  .then((documentUrl) {
                if (documentUrl != null) {
                  setState(() {
                    selectedDocumentUrl = documentUrl;
                    documents.add(Document(
                      documentName: _documentNameController.text,
                      documentUrl: documentUrl,
                    ));
                  });
                }
              });
            },
            borderRadius: 10,
            btnColor: Colors.white,
            width: 60,
            height: 50,
            boxBorder: Border.all(color: Pallete.primaryColor),
            child: Icon(Icons.upload, color: Pallete.primaryColor),
          ),
        )
      ],
    );
  }

  Widget _buildCompletionSwitch() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
          border: Border.all(color: Pallete.greyAccent),
          borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: const Text(
          'Is Completed?',
          style: TextStyle(fontSize: 12),
        ),
        trailing: CustomSwitch(
          height: 25,
          activeColor: Pallete.primaryColor,
          value: _isCompleted,
          onChanged: (bool value) {
            setState(() {
              _isCompleted = value;
            });
          },
        ),
      ),
    );
  }

  Widget _buildUpdateButton() {
    return Center(
      child: GeneralButton(
        onTap: () {
          final updatedShift = widget.shift.copyWith(
            documents: documents,
            done: _isCompleted,
          );
          ShiftHelpers.validateAndSubmitShift(shift: updatedShift);
        },
        borderRadius: 10,
        btnColor: Pallete.primaryColor,
        width: 300,
        child: const Text(
          "Update shift",
          style: TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
