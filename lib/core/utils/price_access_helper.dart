import 'package:get/get.dart';
import 'package:skill_grow/features/profile/controller/profile_data_cotroller.dart';

class PriceAccessHelper {
  // أضف هنا البريد أو الأيميلات المسموح لها بمشاهدة الأسعار كـ "مجاني".
  static const List<String> _freeAccessEmails = [
    'mohammedelabud9@gmail.com',
    'buraidah@demo.com',
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

  static bool shouldHideCart() => isFreeAccessEnabled();

  static String formatPrice(dynamic price, {String fallback = 'مجاني'}) {
    if (isFreeAccessEnabled()) {
      return 'مجاني';
    }

    if (price == null) {
      return fallback;
    }

    return price.toString();
  }
}
