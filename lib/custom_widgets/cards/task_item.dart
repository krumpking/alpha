import 'package:alpha/core/constants/color_constants.dart';
import 'package:alpha/features/shift/models/shift.dart';
import 'package:flutter/material.dart';

class TaskItemCard extends StatelessWidget {
  final Shift shift;
  final bool isUpcomingShift;
  const TaskItemCard({
    super.key,
    required this.shift,
    required this.isUpcomingShift,
  });

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
            title: Text(shift.placeName,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(
              shift.notes,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          const Divider(
            color: Colors.grey,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("${shift.date}    ${shift.startTime}-${shift.endTime}",
                  style: TextStyle(fontSize: 12, color: Pallete.primaryColor)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: shift.done
                      ? Colors.green
                      : isUpcomingShift
                          ? Colors.blue
                          : Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                    shift.done
                        ? 'Completed'
                        : isUpcomingShift
                            ? 'Available'
                            : 'Incomplete',
                    style: const TextStyle(color: Colors.white, fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
