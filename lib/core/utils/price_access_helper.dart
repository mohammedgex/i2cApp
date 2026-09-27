import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:skill_grow/features/profile/controller/profile_data_cotroller.dart';

class PriceAccessHelper {
  // أضف هنا البريد أو الأيميلات المسموح لها بمشاهدة الأسعار كـ "مجاني".
  static const List<String> _freeAccessEmails = [
    'mohammedelabud9@gmail.com',
    'hanim3253@gmail.com',
  ];

  static ProfileDataCotroller? _getProfileController() {
    if (Get.isRegistered<ProfileDataCotroller>()) {
      return Get.find<ProfileDataCotroller>();
    }

    final controller = Get.put(ProfileDataCotroller(), permanent: true);
    if (controller.userDataResponse.value == null &&
        !controller.isLoading.value) {
      controller.fetchData();
    }
    return controller;
  }

  static bool isFreeAccessEnabled() {
    final controller = _getProfileController();
    final user = controller?.userDataResponse.value?.data;
    if (user == null || user.email.trim().isEmpty) {
      return false;
    }

    final currentEmail = user.email.trim().toLowerCase();

    return _freeAccessEmails
        .any((email) => email.trim().toLowerCase() == currentEmail);
  }

  static bool shouldHideCommercialInfo() {
    final controller = _getProfileController();
    if (controller != null &&
        controller.isLoading.value &&
        controller.userDataResponse.value == null) {
      return true;
    }

    return isFreeAccessEnabled();
  }

  static bool shouldHideCart() => shouldHideCommercialInfo();

  static Widget hideCommercialContent(Widget child) => Obx(
        () => shouldHideCommercialInfo() ? const SizedBox.shrink() : child,
      );

  static String formatPrice(dynamic price, {String fallback = 'مجاني'}) {
    if (price == null) {
      return fallback;
    }

    return price.toString();
  }
}
