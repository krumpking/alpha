import 'package:alpha/core/constants/color_constants.dart';
import 'package:flutter/material.dart';

class TaskItemCard extends StatelessWidget {
  final String name;
  final String role;
  final String type;
  final String time;
  const TaskItemCard({super.key, required this.name, required this.role, required this.type, required this.time});

  @override
  Widget build(BuildContext context) {
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
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(
              role,
              style: const TextStyle(
                fontSize: 12
              ),
            ),
          ),
          const Divider(
            color: Colors.grey,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                  time,
                  style: TextStyle(
                      fontSize: 12,
                    color: Pallete.primaryColor
                  )
              ),
              const SizedBox(height: 4),
      
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: type == 'Alpha' ? Colors.green : Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(type, style: const TextStyle(color: Colors.white, fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
