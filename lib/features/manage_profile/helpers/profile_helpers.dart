import 'package:alpha/models/document.dart';
import 'package:alpha/models/shift.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileHelpers{
  static String documentStatus(Document document){

    final DateTime expiryDate = DateFormat('yyyy/MM/dd').parse(document.expiryDate!);
    final DateTime currentDate = DateTime.now();

    final int daysUntilExpiry = expiryDate.difference(currentDate).inDays;

    // Determine the color and status text based on the daysUntilExpiry
    String statusText;

    if (daysUntilExpiry < 0) {
      statusText = 'Expired';

      return statusText;
    } else if (daysUntilExpiry <= 15) {
      // The document expires in 15 days or less
      statusText = '$daysUntilExpiry days left';
      return statusText;
    } else {
      // The document is valid (more than 15 days until expiry)
      statusText = 'Valid';
     return statusText;
    }
  }


  static String shiftHours(Shift shift){
    // Parse the start and end times to DateTime objects
    final DateTime startTime = DateFormat('HH:mm').parse(shift.startTime);
    final DateTime endTime = DateFormat('HH:mm').parse(shift.endTime);

    // Calculate the duration
    final Duration shiftDuration = endTime.difference(startTime);

    // Get the total hours and minutes
    final int hours = shiftDuration.inHours;
    final int minutes = shiftDuration.inMinutes.remainder(60);

    // Format the shift duration as a string
    return'${hours}h ${minutes}m';
  }

  static Future<void> viewDocument(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      Get.snackbar('Error', 'Could not open the document.');
    }
  }
}