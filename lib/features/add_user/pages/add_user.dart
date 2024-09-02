import 'package:alpha/core/constants/color_constants.dart';
import 'package:alpha/custom_widgets/custom_button/general_button.dart';
import 'package:alpha/custom_widgets/text_fields/custom_text_field.dart';
import 'package:alpha/features/add_user/helper/media_helpers.dart';
import 'package:alpha/features/add_user/helper/storage_helper.dart';
import 'package:alpha/global/global.dart';
import 'package:extended_phone_number_input/consts/enums.dart';
import 'package:extended_phone_number_input/phone_number_controller.dart';
import 'package:extended_phone_number_input/phone_number_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../custom_widgets/custom_dropdown.dart';
import '../../../models/user_profile.dart';
import '../helper/add_user_helper.dart';
import '../state/profilr_pic_provider.dart';

class AdminAddUser extends ConsumerStatefulWidget {
  const AdminAddUser({super.key});

  @override
  ConsumerState<AdminAddUser> createState() => _AdminAddUserState();
}


class _AdminAddUserState extends ConsumerState<AdminAddUser> {
  String selectedRole = 'User';
  PhoneNumberInputController? phoneNumberController;
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController previousEmployerController = TextEditingController();
  TextEditingController contactInformationController = TextEditingController();
  TextEditingController documentNameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController preferredWorkDayController = TextEditingController();
  String selectedGender = 'Male';
  String selectedCity = 'Harare';
  String selectedPost = "Nurse";
  List<String> specialisations = [];
  String? selectedDocumentUrl;
  DateTime? expiryDate;
  DateTime? preferredWorkDay;
  DateTime? dob;

  @override
  void initState() {
    super.initState();
    phoneNumberController = PhoneNumberInputController(context);
  }


  @override
  Widget build(BuildContext context) {
    final profilePictureUrl = ref.watch(staffProfilePicProvider);


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.primaryColor,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Add User',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                await MediaHelpers.onUploadMediaClick(
                  documentName: 'Display Picture',
                  ref: ref,
                  isStaffProfile: true,
                );

              },
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.contain,
                    image: profilePictureUrl != null
                        ? NetworkImage(profilePictureUrl)
                        : const NetworkImage(
                      'https://cdn-icons-png.flaticon.com/128/15315/15315520.png',
                    ),
                  ),
                  border: Border.all(
                    color: Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
            ),


            const SizedBox(height: 30),
            CustomDropDown(
              prefixIcon: Icons.person,
              items: const ['Admin', 'User'],
              selectedValue: selectedRole,
              onChanged: (value) {
                setState(() {
                  selectedRole = value!;
                });
              },
              isEnabled: true,
            ),
            const SizedBox(height: 10),

            CustomTextField(
              controller: nameController,
              labelText: 'Name',
              prefixIcon: const Icon(Icons.person, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () async{
                dob = await AddUserHelper.pickDate(context: context, initialDate: DateTime(2000));
                setState(() {

                });
              },
              child: CustomTextField(
                labelText: 'Date of Birth',
                prefixIcon: const Icon(Icons.cake, color: Colors.grey),
                enabled: false,
                controller: TextEditingController(
                  text: dob != null
                      ? DateFormat('yyyy-MM-dd').format(dob!)
                      : '',
                ),
              ),
            ),

            const SizedBox(height: 10),
            CustomDropDown(
              prefixIcon: Icons.transgender,
              items: const ['Male', 'Female', 'Other'],
              selectedValue: selectedGender,
              onChanged: (value) {
                setState(() {
                  selectedGender = value!;
                });
              },
              isEnabled: true,
            ),
            const SizedBox(height: 10),
            CustomTextField(
              controller: emailController,
              labelText: 'Email Address',
              prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            CustomTextField(
              controller: addressController,
              labelText: 'Address',
              prefixIcon: const Icon(Icons.home, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            CustomDropDown(
              prefixIcon: Icons.location_city,
              items: zimbabweCities,
              selectedValue: selectedCity,
              onChanged: (value) {
                setState(() {
                  selectedCity = value!;
                });
              },
              isEnabled: true,
            ),
            const SizedBox(height: 10),
            PhoneNumberInput(
              initialCountry: 'ZW',
              locale: 'fr',
              errorText: 'Invalid Phone Number',
              controller: phoneNumberController,
              countryListMode: CountryListMode.bottomSheet,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Pallete.primaryColor),
              ),
              allowPickFromContacts: false,
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                preferredWorkDayController.text = await AddUserHelper.showWeekPicker(context);

                setState(() {

                });
              },
              child: CustomTextField(
                labelText: 'Preferred Work Days',
                prefixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
                enabled: false,
                controller: preferredWorkDayController,
              ),
            ),
            const SizedBox(height: 10),
            CustomTextField(
              controller: previousEmployerController,
              labelText: 'Previous Employer\'s Name',
              prefixIcon: const Icon(Icons.business_center, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            CustomTextField(
              controller: contactInformationController,
              labelText: 'Contact Information',
              prefixIcon: const Icon(Icons.phone, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            CustomDropDown(
              prefixIcon: Icons.work,
              items: const [
                'Nurse',
                'Social Worker',
                'Care/Support Worker',
                'Range'
              ],
              selectedValue: selectedPost,
              onChanged: (value) {
                setState(() {
                  selectedPost = value!;
                });
              },
              isEnabled: true,
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: specialisations
                  .map((spec) => Chip(
                label: Text(spec),
                backgroundColor:
                Pallete.primaryColor.withOpacity(0.7),
                deleteIcon: const Icon(Icons.close),
                onDeleted: () {
                  setState(() {
                    specialisations.remove(spec);
                  });
                },
              ))
                  .toList(),
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Specialisations',
                prefixIcon: Icon(Icons.medical_services, color: Colors.grey),
              ),
              onSubmitted: (value){
                AddUserHelper.addSpecialisation(
                  value: value,
                  specialisations: specialisations
                );

                setState(() {

                });
              },
            ),
            const SizedBox(height: 10),

            GestureDetector(
              onTap: () async {
                selectedDocumentUrl = await StorageHelper.triggerDocUpload();

                setState(() {

                });
              },
              child: CustomTextField(
                labelText: 'Document',
                prefixIcon: const Icon(Icons.file_present, color: Colors.grey),
                enabled: false,
                controller: TextEditingController(
                  text: selectedDocumentUrl ?? '',
                ),
              ),
            ),



            const SizedBox(height: 10),
            GestureDetector(
              onTap: ()async{
                expiryDate = await AddUserHelper.pickDate(
                  context: context,
                  initialDate: DateTime.now(),
                );

                setState(() {

                });
              },
              child: CustomTextField(
                labelText: 'Expiry Date',
                prefixIcon: const Icon(Icons.date_range, color: Colors.grey),
                enabled: false,
                controller: TextEditingController(
                  text: expiryDate != null
                      ? DateFormat('yyyy-MM-dd').format(expiryDate!)
                      : '',
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: GeneralButton(
                onTap: () => AddUserHelper.validateAndSubmitForm(
                  email: emailController.text.trim(),
                  phoneNumber: phoneNumberController!.fullPhoneNumber.trim(),
                  password: "alpha1234",
                  role: selectedRole,
                  userProfile: UserProfile(
                    post: selectedPost,
                    name: nameController.text.trim(),
                    email: emailController.text.trim(),
                    phoneNumber: phoneNumberController!.fullPhoneNumber.trim(),
                    address: addressController.text.trim(),
                    preferredWorkDays: preferredWorkDay,
                    previousEmployer: previousEmployerController.text.trim(),
                    contactInformation: contactInformationController.text.trim(),
                    role: selectedRole,
                    gender: selectedGender,
                    dob: dob,
                    city: selectedCity,
                    specialisations: specialisations,
                    profilePicture: profilePictureUrl,
                    documentUrl: selectedDocumentUrl,
                    documentName: documentNameController.text.trim(),
                    expiryDate: expiryDate,
                  ),
                ),
                borderRadius: 10,
                btnColor: Pallete.primaryColor,
                width: 150,
                child: const Text(
                  "Add User",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
