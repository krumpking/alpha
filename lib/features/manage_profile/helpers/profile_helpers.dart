import 'package:alpha/models/document.dart';
import 'package:intl/intl.dart';

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
}