import 'package:alpha/core/constants/color_constants.dart';
import 'package:alpha/features/manage_profile/helpers/profile_helpers.dart';
import 'package:alpha/models/document.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../features/add_user/services/storage_services.dart';

class DocumentCard extends StatelessWidget {
  final Document document;
  const DocumentCard({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    String documentStatus = ProfileHelpers.documentStatus(document);

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              document.documentName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            trailing: PopupMenuButton<int>(
              onSelected: (int selectedValue) async {
                switch (selectedValue) {
                  case 0: // View
                    await _viewDocument(document.documentUrl);
                    break;
                  case 1: // Download
                    await _downloadDocument(document.documentUrl);
                    break;
                }
              },
              itemBuilder: (BuildContext context) => [
                buildPopUpOption(
                  title: 'View',
                  icon: Icons.remove_red_eye_outlined,
                  value: 0,
                  onTap: () {
                    // View logic handled in onSelected
                  },
                ),
                buildPopUpOption(
                  title: 'Download',
                  icon: Icons.download,
                  value: 1,
                  onTap: () {
                    // Download logic handled in onSelected
                  },
                ),
              ],
              icon: const Icon(Icons.more_vert),
            ),
          ),
          const Divider(color: Colors.grey),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Expiry Date:  ',
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                    TextSpan(
                      text: '${document.expiryDate}',
                      style: TextStyle(fontSize: 12, color: Pallete.primaryColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: documentStatus.toLowerCase() == 'expired'
                      ? Colors.redAccent
                      : documentStatus.toLowerCase() == 'valid'
                      ? Colors.blue
                      : Colors.orange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  documentStatus,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
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
          Text(title, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Future<void> _viewDocument(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Get.snackbar('Error', 'Could not open the document.');
    }
  }

  Future<void> _downloadDocument(String url) async {
    final response = await StorageServices.downloadAndDecodeFile(url, 'downloads/${basename(url)}');
    if (response.success) {
      Get.snackbar('Success', 'Document downloaded successfully.');
    } else {
      Get.snackbar('Error', response.message ?? 'Failed to download document.');
    }
  }
}
