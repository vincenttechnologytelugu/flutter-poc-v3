// api_service.dart
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class ApiPackage {
  static const String baseUrl = 'http://13.200.179.78';

  Future<bool> savePackageSubscription({
    required String packageId,
    required String userId,
    required String paymentReference,
    required String paymentStatus,
    required String token,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/packages/subscribe'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'package_id': packageId,
          'user_id': userId,
          'payment_reference': paymentReference,
          'payment_status': paymentStatus,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      log('Error saving subscription: $e');
      return false;
    }
  }
}
