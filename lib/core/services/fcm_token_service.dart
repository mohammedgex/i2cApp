import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:skill_grow/core/Global/api_endpoint.dart';
import 'package:skill_grow/core/Global/api_service.dart';
import 'package:skill_grow/core/Global/sharedPref.dart';

class FcmTokenService {
  const FcmTokenService._();

  static Future<void> updateFcmToken({String? token}) async {
    if (kIsWeb) {
      return;
    }

    try {
      final fcmToken = token ?? await FirebaseMessaging.instance.getToken();
      if (fcmToken == null || fcmToken.trim().isEmpty) {
        return;
      }

      final savedToken = await SharedPrefUtil.get('token', '');
      final authToken =
          savedToken is String ? savedToken : savedToken.toString();

      if (authToken.trim().isEmpty) {
        await SharedPrefUtil.put('fcm_token', fcmToken);
        return;
      }

      final response = await ApiService().postData(
        url: ApiEndpoint.updateFcmTokenUrl,
        data: {'fcm_token': fcmToken},
        requiresAuth: true,
        showSnackbar: false,
      );

      debugPrint('FCM token to send: $fcmToken');
      debugPrint('FCM token update status: ${response?.statusCode}');
      debugPrint('FCM token update body: ${response?.data}');

      if (response != null &&
          (response.statusCode == 200 ||
              response.statusCode == 201 ||
              response.statusCode == 204)) {
        await SharedPrefUtil.put('fcm_token', fcmToken);
        return;
      }

      debugPrint(
          'FCM token update request failed or returned unexpected status.');
    } catch (e, stackTrace) {
      debugPrint('FcmTokenService.updateFcmToken error: $e');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  static Future<void> deleteLocalFcmToken() async {
    try {
      await FirebaseMessaging.instance.deleteToken();
    } catch (_) {
      // Ignore delete-token errors and still clear the local copy.
    }

    await SharedPrefUtil.remove('fcm_token');
  }
}
