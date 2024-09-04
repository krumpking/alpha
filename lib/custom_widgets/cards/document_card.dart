import 'package:alpha/core/constants/color_constants.dart';
import 'package:alpha/features/manage_profile/helpers/profile_helpers.dart';
import 'package:alpha/models/document.dart';
import 'package:flutter/material.dart';

class DocumentCard extends StatelessWidget {
  final Document document;
  const DocumentCard({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    String documentStatus = ProfileHelpers.documentStatus(document);

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
            title: Text(document.documentName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
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
                        text: 'Expiry Date:  ',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.black
                        )
                    ),

                    TextSpan(
                        text: '${document.expiryDate}',
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
                  color: documentStatus.toLowerCase() == 'expired' ? Colors.redAccent : documentStatus.toLowerCase() == 'valid' ? Colors.blue : Colors.orange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(documentStatus, style: const TextStyle(color: Colors.white, fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
