import 'package:alpha/core/utils/string_methods.dart';
import 'package:alpha/features/hours_worked/helpers/add_hours_worked.dart';
import 'package:alpha/features/hours_worked/models/hours_worked.dart';
import 'package:alpha/features/workers/helper/storage_helper.dart';
import 'package:alpha/features/documents/models/document.dart';
import 'package:alpha/features/manage_profile/models/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/color_constants.dart';
import '../../../custom_widgets/custom_button/general_button.dart';
import '../../../custom_widgets/text_fields/custom_text_field.dart';
import '../../shift/helpers/shift_helpers.dart';
import '../../workers/services/media_services.dart';

class AddHoursWorkedScreen extends StatefulWidget {
  final UserProfile selectedUser;
  const AddHoursWorkedScreen({super.key, required this.selectedUser});

  @override
  State<AddHoursWorkedScreen> createState() => _AddHoursWorkedScreenState();
}

class _AddHoursWorkedScreenState extends State<AddHoursWorkedScreen> {
  final TextEditingController _documentNameController = TextEditingController();
  final TextEditingController _hoursWorkedController = TextEditingController();
  User? currentUser;
  List<Document> documents = [];
  String selectedDocumentUrl = "";
  dynamic selectedFile;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    documents = [];
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
              keyBoardType: const TextInputType.numberWithOptions(
                  decimal: false, signed: false),
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
            Icons.calendar_month,
            size: 100,
            color: Pallete.primaryColor,
          ),
        ),
        Text(
          'Add Hours Worked',
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
              selectedFile = await MediaServices.pickDocument();
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

  Widget _buildUpdateButton() {
    return Center(
      child: GeneralButton(
        onTap: () async {
          await StorageHelper.triggerDocUpload(documentName:  _documentNameController.text, selectedFile: selectedFile)
              .then((documentUrl) {
            if (documentUrl != null) {
              setState(() {
                selectedDocumentUrl = documentUrl;
                documents.add(Document(
                  docID: StringMethods.generateRandomString(),
                  documentName: _documentNameController.text,
                  documentUrl: documentUrl,
                ));
              });
            }
          });

          var id = StringMethods.generateRandomString();
          var addedBy = currentUser != null
              ? currentUser!.email
              : "Admin user account not found";

          await StorageHelper.triggerDocUpload(
              documentName: _documentNameController.text,
              selectedFile: selectedFile)
              .then((documentUrl) {
            if (documentUrl != null) {
              setState(() {
                selectedDocumentUrl = documentUrl;
                documents.add(Document(
                  docID: StringMethods.generateRandomString(),
                  documentName: _documentNameController.text,
                  expiryDate: '',
                  documentUrl: documentUrl,
                ));
              });
            }
          });


          HoursWorked hoursWorked = HoursWorked(
            id: id,
            addedBy: addedBy!,
            staffEmail: widget.selectedUser.email!,
            dateAdded: DateTime.now(),
            documents: documents,
            hoursWorked: double.parse(_hoursWorkedController.text),
          );

          AddHoursWorkedHelper.validateAndSubmitHoursWorked(hoursWorked: hoursWorked);
        },
        borderRadius: 10,
        btnColor: Pallete.primaryColor,
        width: 300,
        child: const Text(
          "Add Hours Worked",
          style: TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
