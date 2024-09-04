import 'package:alpha/custom_widgets/cards/shifts_card.dart';
import 'package:alpha/models/shift.dart';
import 'package:flutter/material.dart';

class ShiftsTab extends StatefulWidget {
  final List<Shift> shifts;
  const ShiftsTab({super.key, required this.shifts});

  @override
  State<ShiftsTab> createState() => _ShiftsTabState();
}

class _ShiftsTabState extends State<ShiftsTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: widget.shifts.length,
        itemBuilder: (context, index) {
          final shift = widget.shifts[index];

          return ShiftCard(
            shift: shift,
          );
        },
      ),
    );
  }
}
