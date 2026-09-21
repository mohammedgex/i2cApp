import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:skill_grow/core/Global/api_endpoint.dart';
import 'package:skill_grow/core/Global/api_service.dart';
import 'package:skill_grow/core/Global/sharedPref.dart';
import 'package:skill_grow/core/services/fcm_token_service.dart';
import 'package:skill_grow/core/widgets/snackbar.dart';
import 'package:skill_grow/features/authentication/view/login_view.dart';

class DeleteAccountController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  Future<bool> deleteAccount() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final apiService = ApiService();
      final response = await apiService.deleteData(
        url: ApiEndpoint.deleteAccountUrl,
        requiresAuth: true,
        showSnackbar: false,
      );

      if (response != null &&
          (response.statusCode == 200 ||
              response.statusCode == 201 ||
              response.statusCode == 204)) {
        await SharedPrefUtil.clear();
        await FcmTokenService.deleteLocalFcmToken();
        await FirebaseMessaging.instance.deleteToken();

        if (Get.context != null) {
          customSnackbar(
            title: 'تم الحذف',
            message: 'تم حذف حسابك بنجاح.',
            type: CustomSnackbarType.success,
          );
        }

        Get.offAll(() => LoginView());
        return true;
      }

      errorMessage.value = 'فشل حذف الحساب. حاول مرة أخرى.';
      if (Get.context != null) {
        customSnackbar(
          title: 'خطأ',
          message: errorMessage.value,
          type: CustomSnackbarType.failed,
        );
      }
      return false;
    } catch (e) {
      errorMessage.value = 'حدث خطأ أثناء حذف الحساب: $e';
      if (Get.context != null) {
        customSnackbar(
          title: 'خطأ',
          message: errorMessage.value,
          type: CustomSnackbarType.failed,
        );
      }
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
