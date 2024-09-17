import 'package:alpha/core/constants/color_constants.dart';
import 'package:alpha/features/manage_profile/helpers/profile_helpers.dart';
import 'package:alpha/features/shift/helpers/shift_helpers.dart';
import 'package:alpha/features/shift/models/shift.dart';
import 'package:alpha/features/manage_profile/models/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tap_to_expand/tap_to_expand.dart';

import '../../core/utils/routes.dart';

class ShiftCard extends StatelessWidget {
  final Shift shift;
  final bool isUpcomingShift;
  final UserProfile selectedUser;
  const ShiftCard(
      {super.key,
      required this.shift,
      required this.isUpcomingShift,
      required this.selectedUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey)),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TapToExpand(
                  backgroundcolor: Pallete.whiteColor,
                  content: Column(
                    children: [
                      const SizedBox(height: 2),
                      ListTile(
                        title: Text(
                          'Shift duration: ${shift.duration}',
                        ),
                      ),
                      SizedBox(height: 4),
                      ListTile(
                        title: Text(
                          'Shift Notes: ${shift.notes}',
                        ),
                      ),
                      const SizedBox(height: 4),
                      ListTile(
                          title: Text(
                        'Shift Contact Person: ${shift.contactPersonNumber} or ${shift.contactPersonAltNumber}',
                      )),
                      const SizedBox(height: 4),
                      ListTile(
                        title: Text(
                          'Staff Email: ${shift.staffEmail}',
                        ),
                      ),
                    ],
                  ),
                  title: Text(shift.placeName,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                  closedHeight: 70,
                  borderRadius: BorderRadius.circular(16),
                  openedHeight: 200,
                ),
                const SizedBox(
                  height: 8,
                ),
                if (!isUpcomingShift)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: shift.done ? Colors.blue : Pallete.redColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(shift.done ? 'Completed' : 'Incomplete',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12)),
                  ),
              ],
            ),
            trailing: PopupMenuButton<int>(
                    onSelected: (int selectedValue) {
                      // Handle the selected value
                      switch (selectedValue) {
                        case 0:
                          break;
                        case 1:
                          break;
                        case 2:
                          break;
                        case 3:
                          break;
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                        buildPopUpOption(
                            title: 'Edit',
                            icon: Icons.edit,
                            value: 0,
                            onTap: () => Get.toNamed(
                                RoutesHelper.editShiftScreen,
                                arguments: [selectedUser, shift])),
                      buildPopUpOption(
                          title: 'Add Feedback',
                          icon: Icons.feedback,
                          value: 1,
                          onTap: () => Get.toNamed(
                              RoutesHelper.addUserFeedbackScreen,
                              arguments: [selectedUser, shift])),
                      if (shift.done) buildPopUpOption(
                          title: 'Add Hours Worked',
                          icon: Icons.watch_later_outlined,
                          value: 2,
                          onTap: () => Get.toNamed(
                              RoutesHelper.addHoursWorkedScreen,
                              arguments: [selectedUser, shift])),
                      if (shift.done) buildPopUpOption(
                          title: 'Remove',
                          icon: Icons.visibility_off,
                          value: 3,
                          onTap: (){
                            final updatedShift = shift.copyWith(
                              visible: true
                            );

                            ShiftHelpers.updateShift(shift: updatedShift);
                          }
                      )
                    ],
                    icon: const Icon(Icons.more_vert),
                  )
          ),
          const Divider(
            color: Colors.grey,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              RichText(
                text: TextSpan(children: [
                  const TextSpan(
                      text: 'Shift:  ',
                      style: TextStyle(fontSize: 12, color: Colors.black)),
                  TextSpan(
                      text: '${shift.date} ${shift.startTime}-${shift.endTime}',
                      style:
                          TextStyle(fontSize: 12, color: Pallete.primaryColor)),
                ]),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(shift.duration,
                    style: const TextStyle(color: Colors.white, fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  dynamic buildPopUpOption({
    required String title,
    required IconData icon,
    required int value,
    required void Function() onTap,
  }) {
    return PopupMenuItem<int>(
      onTap: onTap,
      value: value,
      child: Row(
        children: [
          Icon(icon, color: Colors.black54),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
