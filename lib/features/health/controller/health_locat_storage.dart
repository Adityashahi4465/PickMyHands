import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final healthLocalStorageProvider = Provider<HealthtLocalStorage>((ref) {
  return HealthtLocalStorage();
});

class HealthtLocalStorage {
  static const _keyPrescriptions = 'prescriptions';
  Future<void> savePrescriptionData(
      Map<String, List<dynamic>> prescriptions) async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonData = json.encode(prescriptions);
    prefs.setString(_keyPrescriptions, jsonData);
  }

  Future<List<Map<String, dynamic>>> getPrescriptionData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonData = prefs.getString(_keyPrescriptions);
    if (jsonData != null) {
      final List<dynamic> decodedData = json.decode(jsonData);
      print(
          'fdffffffffffffffffffffff ${decodedData.cast<Map<String, dynamic>>()}');
      return decodedData.cast<Map<String, dynamic>>();
    }
    return [];
  }
}
