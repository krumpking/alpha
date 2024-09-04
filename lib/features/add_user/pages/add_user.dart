import 'dart:io';
import 'package:alpha/models/shift.dart';
import 'package:alpha/models/document.dart';
import 'package:alpha/core/constants/color_constants.dart';
import 'package:alpha/custom_widgets/custom_button/general_button.dart';
import 'package:alpha/custom_widgets/text_fields/custom_text_field.dart';
import 'package:alpha/features/add_user/helper/storage_helper.dart';
import 'package:extended_phone_number_input/consts/enums.dart';
import 'package:extended_phone_number_input/phone_number_controller.dart';
import 'package:extended_phone_number_input/phone_number_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/utils/providers.dart';
import '../../../custom_widgets/country_city_state/country_city_state.dart';
import '../../../custom_widgets/custom_dropdown.dart';
import '../../../custom_widgets/snackbar/custom_snackbar.dart';
import '../../../models/user_profile.dart';
import '../helper/add_user_helper.dart';
import '../services/media_services.dart';
import '../services/storage_services.dart';

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
  TextEditingController shiftDayController = TextEditingController();
  TextEditingController shiftStartTimeController = TextEditingController();
  TextEditingController shiftEndTimeController = TextEditingController();
  TextEditingController specilizationTextEditingController =
      TextEditingController();
  String selectedGender = 'Male';
  String? selectedCity;
  String? selectedState;
  String? selectedCountry;
  String selectedPost = "Nurse";
  List<String> specialisations = [];
  List<Document> documents = [];
  List<Shift> preferredWorkDays = [];
  String? selectedDocumentUrl;
  TextEditingController expiryDateTextEditing = TextEditingController();
  DateTime? dob;
  File? pickedImage;

  @override
  void initState() {
    super.initState();
    phoneNumberController = PhoneNumberInputController(context);
  }

  @override
  Widget build(BuildContext context) {
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
            Center(
                child: GestureDetector(
              onTap: () async {
                await MediaServices.getImageFromGallery().then((file) {
                  setState(() {
                    pickedImage = file;
                  });
                });
              },
              child: Stack(
                children: [
                  // Profile Picture
                  Container(
                    width: 150,
                    height: 150,
                    padding: const EdgeInsets.all(4),
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Pallete.primaryColor,
                        width: 2,
                      ),
                    ),
                    child: pickedImage != null
                        ? ClipOval(
                            child: Image.network(
                              pickedImage!.path,
                              fit: BoxFit.cover,
                              width: 150,
                              height: 150,
                            ),
                          )
                        : const Icon(
                            Icons.add_a_photo_outlined,
                            size: 100,
                            color: Colors.grey,
                          ),
                  ),
                  // Icon Overlay
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Pallete.primaryColor),
                      padding: const EdgeInsets.all(8.0),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            )),

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
              onTap: () async {
                dob = await AddUserHelper.pickDate(
                    context: context,
                    initialDate: DateTime(2000),
                    firstDate: DateTime(1900));
                setState(() {});
              },
              child: CustomTextField(
                labelText: 'Date of Birth',
                prefixIcon: const Icon(Icons.cake, color: Colors.grey),
                enabled: false,
                controller: TextEditingController(
                  text:
                      dob != null ? DateFormat('yyyy-MM-dd').format(dob!) : '',
                ),
              ),
            ),
            const SizedBox(height: 10),
            CustomDropDown(
              prefixIcon: Icons.transgender,
              items: const ['Male', 'Female'],
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
            CountryCityState(
              onSelectionChanged: (country, state, city) {
                setState(() {
                  selectedCity = city;
                  selectedState = state;
                  selectedCountry = country;
                });
              },
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
            CustomTextField(
              controller: previousEmployerController,
              labelText: 'Previous Employer\'s Name',
              prefixIcon: const Icon(Icons.business_center, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            CustomTextField(
              controller: contactInformationController,
              labelText: 'Previous Employer\'s Contact Information',
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
            const Divider(),

            Container(
              child: Column(
                children: [
                  const Text(
                    'Specializations',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: specialisations
                        .map((spec) => Chip(
                              label: Text(
                                spec,
                                style: const TextStyle(
                                    fontSize: 10, color: Colors.white),
                              ),
                              backgroundColor:
                                  Pallete.primaryColor.withOpacity(0.7),
                              deleteIcon: const Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                              onDeleted: () {
                                setState(() {
                                  specialisations.remove(spec);
                                });
                              },
                            ))
                        .toList(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    labelText: 'Specialisations',
                    controller: specilizationTextEditingController,
                    prefixIcon:
                        const Icon(Icons.medical_services, color: Colors.grey),
                    onSubmitted: (value) {
                      setState(() {
                        AddUserHelper.addSpecialisation(
                            value: value!, specialisations: specialisations);

                        specilizationTextEditingController.text = '';
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),
            const Divider(),

            Container(
              child: Column(
                children: [
                  const Text(
                    'Preferred Work Days',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    children: preferredWorkDays.map((shift) {
                      return Chip(
                        label: Text(
                          '${shift.day}: ${shift.startTime} - ${shift.endTime}',
                          style: const TextStyle(
                              fontSize: 10, color: Colors.white),
                        ),
                        backgroundColor: Pallete.primaryColor.withOpacity(0.7),
                        deleteIcon: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                        onDeleted: () {
                          setState(() {
                            preferredWorkDays.remove(shift);
                          });
                        },
                      );
                    }).toList(),
                  ),
                  CustomTextField(
                    controller: shiftDayController,
                    prefixIcon: const Icon(
                      Icons.calendar_month,
                      color: Colors.grey,
                    ),
                    labelText: 'Day of the Week',
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            await AddUserHelper.pickTime(context: context)
                                .then((timeOfDay) {
                              setState(() {
                                if (timeOfDay != null) {
                                  final now = DateTime.now();
                                  final dateTime = DateTime(
                                      now.year,
                                      now.month,
                                      now.day,
                                      timeOfDay.hour,
                                      timeOfDay.minute);

                                  String formattedTime =
                                      DateFormat('HH:mm').format(dateTime);
                                  shiftStartTimeController.text = formattedTime;
                                }
                              });
                            });
                          },
                          child: CustomTextField(
                            enabled: false,
                            controller: shiftStartTimeController,
                            prefixIcon: const Icon(
                              Icons.watch_later_outlined,
                              color: Colors.grey,
                            ),
                            labelText: 'Start Time',
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            await AddUserHelper.pickTime(context: context)
                                .then((timeOfDay) {
                              setState(() {
                                if (timeOfDay != null) {
                                  final now = DateTime.now();
                                  final dateTime = DateTime(
                                      now.year,
                                      now.month,
                                      now.day,
                                      timeOfDay.hour,
                                      timeOfDay.minute);

                                  String formattedTime =
                                      DateFormat('HH:mm').format(dateTime);
                                  shiftEndTimeController.text = formattedTime;
                                }
                              });
                            });
                          },
                          child: CustomTextField(
                            enabled: false,
                            controller: shiftEndTimeController,
                            prefixIcon: const Icon(
                              Icons.watch_later_outlined,
                              color: Colors.grey,
                            ),
                            labelText: 'End Time',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  GeneralButton(
                    onTap: () {
                      setState(() {
                        preferredWorkDays.add(
                          Shift(
                            day: shiftDayController.text.trim(),
                            startTime: shiftStartTimeController.text.trim(),
                            endTime: shiftEndTimeController.text.trim(),
                          ),
                        );
                      });
                      shiftDayController.clear();
                      shiftStartTimeController.clear();
                      shiftEndTimeController.clear();
                    },
                    borderRadius: 10,
                    btnColor: Colors.white,
                    boxBorder: Border.all(color: Pallete.primaryColor),
                    width: 150,
                    height: 40,
                    child: Text(
                      "Add Shift",
                      style: TextStyle(
                          color: Pallete.primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            const Divider(),

            const SizedBox(height: 20),
            // Multiple Documents Section
            Container(
              child: Column(
                children: [
                  const Text(
                    'Documents',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    children: documents.map((document) {
                      return Chip(
                        label: Text(document.documentName,
                            style: const TextStyle(
                                fontSize: 10, color: Colors.white)),
                        backgroundColor: Pallete.primaryColor.withOpacity(0.7),
                        deleteIcon: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                        onDeleted: () {
                          setState(() {
                            documents.remove(document);
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: documentNameController,
                    labelText: 'Document Name',
                    prefixIcon:
                        const Icon(Icons.description, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
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
                  const SizedBox(height: 10),
                  GeneralButton(
                    onTap: () async {
                      await StorageHelper.triggerDocUpload()
                          .then((documentUrl) {
                        if (documentUrl != null) {
                          selectedDocumentUrl = documentUrl;

                          setState(() {
                            documents.add(
                              Document(
                                documentName:
                                    documentNameController.text.trim(),
                                documentUrl: selectedDocumentUrl!,
                                expiryDate: expiryDateTextEditing.text,
                              ),
                            );
                            documentNameController.clear();
                            expiryDateTextEditing.clear();
                          });
                        }
                      });
                    },
                    borderRadius: 10,
                    btnColor: Colors.white,
                    width: 150,
                    height: 40,
                    boxBorder: Border.all(color: Pallete.primaryColor),
                    child: Text(
                      "Add Document",
                      style: TextStyle(
                          color: Pallete.primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            Center(
              child: GeneralButton(
                onTap: () async {
                  if (pickedImage != null) {
                    await StorageServices.uploadDp(
                      file: pickedImage!,
                    ).then((response) {
                      if (response.success) {
                        AddUserHelper.validateAndSubmitForm(
                          userProfile: UserProfile(
                            post: selectedPost,
                            name: nameController.text.trim(),
                            email: emailController.text.trim(),
                            phoneNumber:
                                phoneNumberController!.fullPhoneNumber.trim(),
                            address: addressController.text.trim(),
                            preferredWorkDays: preferredWorkDays,
                            previousEmployer:
                                previousEmployerController.text.trim(),
                            documents: documents,
                            contactInformation:
                                contactInformationController.text.trim(),
                            role: selectedRole,
                            gender: selectedGender,
                            dob: dob,
                            city: selectedCity!,
                            state: selectedState!,
                            country: selectedCountry!,
                            specialisations: specialisations,
                            profilePicture: response.data,
                          ),
                        );
                      } else {
                        CustomSnackBar.showErrorSnackbar(
                            message:
                                'Failed to upload image, Please try Again');

                        if (Get.isDialogOpen!) Get.back();
                        return;
                      }
                    });
                  } else {
                    AddUserHelper.validateAndSubmitForm(
                      userProfile: UserProfile(
                        post: selectedPost,
                        name: nameController.text.trim(),
                        email: emailController.text.trim(),
                        phoneNumber:
                            phoneNumberController!.fullPhoneNumber.trim(),
                        address: addressController.text.trim(),
                        preferredWorkDays: preferredWorkDays,
                        previousEmployer:
                            previousEmployerController.text.trim(),
                        documents: documents,
                        contactInformation:
                            contactInformationController.text.trim(),
                        role: selectedRole,
                        gender: selectedGender,
                        dob: dob,
                        city: selectedCity!,
                        state: selectedState!,
                        country: selectedCountry!,
                        specialisations: specialisations,
                        profilePicture: null,
                      ),
                    );
                  }
                },
                borderRadius: 10,
                btnColor: Pallete.primaryColor,
                width: 300,
                child: const Text(
                  "Add User",
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
