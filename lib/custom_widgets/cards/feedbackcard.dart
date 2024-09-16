import 'package:alpha/core/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/routes.dart';
import '../../features/feedback/models/feedback_model.dart';

class FeedbackCard extends StatelessWidget {
  final FeedbackModel feedback;
  const FeedbackCard({super.key, required this.feedback,});

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
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text( feedback.feedbackTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
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
                          text: 'Date:  ',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black
                          )
                      ),

                      TextSpan(
                          text: feedback.date,
                          style: TextStyle(
                              fontSize: 12,
                              color: Pallete.primaryColor
                          )
                      ),
                    ]
                ),

              ),
              const SizedBox(height: 4),

              Text(feedback.description, style: const TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
