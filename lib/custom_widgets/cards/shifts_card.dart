import 'package:alpha/core/constants/color_constants.dart';
import 'package:alpha/features/manage_profile/helpers/profile_helpers.dart';
import 'package:alpha/models/shift.dart';
import 'package:flutter/material.dart';

class ShiftCard extends StatelessWidget {
  final Shift shift;
  const ShiftCard({super.key, required this.shift});

  @override
  Widget build(BuildContext context) {
    String shiftHours = ProfileHelpers.shiftHours(shift);

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(
          vertical: 8
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: Colors.grey
          )
      ),
      child: Column(
        children: [
          const ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text('Hospital Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ),
          const Divider(
            color: Colors.grey,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              RichText(
                text: TextSpan(
                    children: [
                      const TextSpan(
                          text: 'Shift:  ',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black
                          )
                      ),

                      TextSpan(
                          text: '${shift.day} ${shift.startTime}-${shift.endTime}',
                          style: TextStyle(
                              fontSize: 12,
                              color: Pallete.primaryColor
                          )
                      ),
                    ]
                ),

              ),
              const SizedBox(height: 4),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(shiftHours, style: const TextStyle(color: Colors.white, fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
