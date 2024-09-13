import 'package:alpha/features/workers/helper/storage_helper.dart';
import 'package:alpha/models/shift.dart';
import 'package:alpha/models/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/color_constants.dart';
import '../../../custom_widgets/custom_button/general_button.dart';
import '../../../custom_widgets/custom_switch/custom_switch.dart';
import '../../../custom_widgets/text_fields/custom_text_field.dart';
import '../../workers/helper/add_user_helper.dart';
import '../helpers/shift_helpers.dart';

class AddUserShift extends StatefulWidget {
  final UserProfile selectedUser;
  const AddUserShift({super.key, required this.selectedUser});

  @override
  State<AddUserShift> createState() => _AddUserShiftState();
}

class _AddUserShiftState extends State<AddUserShift> {
  final TextEditingController _placeNameController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _shiftDateController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _contactPersonController = TextEditingController();
  final TextEditingController _contactPersonAltController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  bool _isCompleted = false;
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
                Icons.calendar_month,
                size: 100,
                color: Pallete.primaryColor,
              ),
            ),

            Text(
              'Add Shift',
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
              controller: _placeNameController,
              labelText: 'Place Name',
              prefixIcon: const Icon(Icons.place, color: Colors.grey),
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
                      _shiftDateController.text = formattedDate;
                    }
                  });
                });
              },
              child: CustomTextField(
                enabled: false,
                controller: _shiftDateController,
                prefixIcon: const Icon(
                  Icons.calendar_month,
                  color: Colors.grey,
                ),
                labelText: 'Shift Date',
              ),
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
                            final dateTime = DateTime(now.year, now.month,
                                now.day, timeOfDay.hour, timeOfDay.minute);

                            String formattedTime =
                            DateFormat('HH:mm').format(dateTime);
                            _startTimeController.text = formattedTime;
                          }
                        });
                      });
                    },
                    child: CustomTextField(
                      enabled: false,
                      controller: _startTimeController,
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
                            final dateTime = DateTime(now.year, now.month,
                                now.day, timeOfDay.hour, timeOfDay.minute);

                            String formattedTime =
                            DateFormat('HH:mm').format(dateTime);
                            _endTimeController.text = formattedTime;
                          }
                        });
                      });
                    },
                    child: CustomTextField(
                      enabled: false,
                      controller: _endTimeController,
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
            const SizedBox(height: 12),
            CustomTextField(
              controller: _durationController,
              labelText: 'Duration',
              prefixIcon: const Icon(Icons.timelapse, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: _contactPersonController,
              labelText: 'Contact Person Number',
              prefixIcon: const Icon(Icons.phone, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: _contactPersonAltController,
              labelText: 'Alternative Contact Number',
              prefixIcon: const Icon(Icons.phone, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: _notesController,
              labelText: 'Notes',
              prefixIcon: const Icon(Icons.notes, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                  border: Border.all(color: Pallete.greyAccent),
                  borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'Is Completed?',
                  style: TextStyle(
                    fontSize: 12,
                  ),
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
            ),
            const SizedBox(height: 20),
            Center(
              child: GeneralButton(
                onTap: () {
                  final shift = Shift(
                    shiftId: "", // generate shift ID here or in backend
                    placeName: _placeNameController.text,
                    startTime: _startTimeController.text,
                    endTime: _endTimeController.text,
                    duration: _durationController.text,
                    date: _shiftDateController.text,
                    dateAdded: DateTime.now().toString(),
                    addedBy: currentUser!.email!,
                    contactPersonNumber: _contactPersonController.text,
                    contactPersonAltNumber: _contactPersonAltController.text,
                    staffEmail: widget.selectedUser.email!,
                    done: _isCompleted,
                    notes: _notesController.text,
                  );

                  ShiftHelpers.addUserShift(
                    shift : shift
                  );
                },
                borderRadius: 10,
                btnColor: Pallete.primaryColor,
                width: 300,
                child: const Text(
                  "Add Shift",
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
