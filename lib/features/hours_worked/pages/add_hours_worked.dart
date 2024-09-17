import 'package:alpha/core/utils/string_methods.dart';
import 'package:alpha/features/workers/helper/storage_helper.dart';
import 'package:alpha/features/hours_worked/models/document.dart';
import 'package:alpha/features/manage_profile/models/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/color_constants.dart';
import '../../../custom_widgets/custom_button/general_button.dart';
import '../../../custom_widgets/custom_switch/custom_switch.dart';
import '../../../custom_widgets/text_fields/custom_text_field.dart';
import '../../shift/models/shift.dart';
import '../../shift/helpers/shift_helpers.dart';

class AddHoursWorkedScreen extends StatefulWidget {
  final UserProfile selectedUser;
  const AddHoursWorkedScreen({super.key, required this.selectedUser});

  @override
  State<AddHoursWorkedScreen> createState() => _AddHoursWorkedScreenState();
}

class _AddHoursWorkedScreenState extends State<AddHoursWorkedScreen> {
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
    _isCompleted = false;
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

  Widget _buildUpdateButton() {
    return Center(
      child: GeneralButton(
        onTap: () async {
          var id = StringMethods.generateRandomString();
          var hours = _hoursWorkedController.text.isNotEmpty
              ? int.parse(_hoursWorkedController.text)
              : 0;
          var addedBy = currentUser != null
              ? currentUser!.uid
              : "Admin user account not found";

          Shift hoursWorked = Shift(
              shiftId: id,
              placeName: "Monthly Record",
              startTime: "Monthly record",
              endTime: "Monthly record",
              duration: hours.toString(),
              hoursWorked: hours,
              date: DateTime.now().toString(),
              visible: true,
              dateAdded: DateTime.now().toString(),
              addedBy: addedBy,
              contactPersonNumber: "contactPersonNumber",
              contactPersonAltNumber: "contactPersonAltNumber",
              staffEmail: "staffEmail",
              done: true,
              notes: "notes");

          ShiftHelpers.validateAndSubmitShift(shift: hoursWorked);
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
