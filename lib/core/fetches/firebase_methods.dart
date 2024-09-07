import 'package:alpha/core/utils/logs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseMethods {
  Future<dynamic> addData(
      Map<String, dynamic> data, String collectionName) async {
    try {
      return await FirebaseFirestore.instance
          .collection(collectionName)
          .add(data);
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> getDataOneField(
      String collectionName, String field, dynamic value) async {
    DevLogs.logInfo('Fetching data for $field with value $value');
    try {
      if (collectionName.isNotEmpty &&
          field.isNotEmpty &&
          value != null &&
          value != '') {
        return FirebaseFirestore.instance
            .collection(collectionName)
            .where(field, isEqualTo: value)
            .get();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> getDataTwoFields(
    String collectionName,
    String fieldOne,
    dynamic valueOne,
    String fieldTwo,
    dynamic valueTwo,
  ) async {
    try {
      return FirebaseFirestore.instance
          .collection(collectionName)
          .where(fieldOne, isEqualTo: valueOne)
          .where(fieldTwo, isEqualTo: valueTwo)
          .get();
    } catch (e) {
      return null;
    }
  }
}
