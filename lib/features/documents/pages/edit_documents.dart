import 'package:alpha/core/utils/string_methods.dart';
import 'package:alpha/features/documents/helpers/document_helper.dart';
import 'package:alpha/features/workers/helper/storage_helper.dart';
import 'package:alpha/features/documents/models/document.dart';
import 'package:alpha/features/manage_profile/models/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/color_constants.dart';
import '../../../custom_widgets/custom_button/general_button.dart';
import '../../../custom_widgets/snackbar/custom_snackbar.dart';
import '../../../custom_widgets/text_fields/custom_text_field.dart';
import '../../workers/helper/add_user_helper.dart';
import '../../workers/services/media_services.dart';

class EditUserDocumentScreen extends StatefulWidget {
  final Document document;
  final UserProfile profile;
  final WidgetRef ref;
  const EditUserDocumentScreen({super.key, required this.document, required this.profile, required this.ref});

  @override
  State<EditUserDocumentScreen> createState() => _EditUserDocumentScreenState();
}

class _EditUserDocumentScreenState extends State<EditUserDocumentScreen> {
  final TextEditingController _documentNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  TextEditingController expiryDateTextEditing = TextEditingController();
  User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    _documentNameController.text = widget.document.documentName;
    descriptionController.text = widget.document.documentDescription ?? '';
    expiryDateTextEditing.text = widget.document.expiryDate ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.primaryColor,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.profile.name!,
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
              controller: descriptionController,
              labelText: 'Description',
              prefixIcon: const Icon(Icons.description, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () async {
                await AddUserHelper.pickDate(
                    context: context, initialDate: DateTime.now())
                    .then((date) {
                  setState(() {
                    if (date != null) {
                      String formattedDate =
                      DateFormat('yyyy/MM/dd').format(date);
                      expiryDateTextEditing.text = formattedDate;
                    }
                  });
                });
              },
              child: CustomTextField(
                enabled: false,
                controller: expiryDateTextEditing,
                prefixIcon: const Icon(
                  Icons.calendar_month,
                  color: Colors.grey,
                ),
                labelText: 'Expiry Date',
              ),
            ),
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
            Icons.edit_document,
            size: 100,
            color: Pallete.primaryColor,
          ),
        ),
        Text(
          'Edit Document',
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
    return Column(
      children: [
        CustomTextField(
          controller: _documentNameController,
          labelText: 'Document Name',
          prefixIcon: const Icon(Icons.description, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildUpdateButton() {
    return Center(
      child: GeneralButton(
        onTap: () async {
          final updatedDocument = widget.document.copyWith(
            documentDescription: descriptionController.text,
            documentName: _documentNameController.text,
            expiryDate: expiryDateTextEditing.text
          );

          DocumentHelper.validateAndUpdateDocument(
            profile: widget.profile,
            updatedDocument: updatedDocument,
            ref: widget.ref,
          );
        },
        borderRadius: 10,
        btnColor: Pallete.primaryColor,
        width: 300,
        child: const Text(
          "Update Document",
          style: TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
