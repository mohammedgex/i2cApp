import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get.dart';
import '../../../core/Global/sharedPref.dart';

class SelectedCurrencyController extends GetxController {
  var selectedIndex = Rxn<int>();

  @override
  void onInit() {
    super.onInit();
    _loadSelectedLanguage(); // Load the selected language when the controller is initialized
  }

  // Method to load the selected language from SharedPreferences
  void _loadSelectedLanguage() async {
    String? currencyCode = await SharedPrefUtil.get('currency_code', 'EGP');
    int? index = await SharedPrefUtil.get('selected_index',
        0); // Assuming you're saving the index in SharedPreferences
    if (currencyCode != null && currencyCode.isNotEmpty) {
      selectedIndex.value = index;
    }
  }

  // Method to save the selected language and reset the app
  void selectItem({
    required int index,
    required String currency_icon,
    required String currency_name,
    required String currency_code,
    required String currency_rate,
    required String currency_position,
    required String status,
    required String is_default,
  }) async {
    // Save language settings to shared preferences
    await SharedPrefUtil.put('currency_icon', currency_icon);
    await SharedPrefUtil.put('currency_name', currency_name);
    await SharedPrefUtil.put('currency_code', currency_code);
    await SharedPrefUtil.put('currency_rate', currency_rate);
    await SharedPrefUtil.put('currency_position', currency_position);
    await SharedPrefUtil.put('is_default', is_default);
    await SharedPrefUtil.put('status', is_default);
    await SharedPrefUtil.put('selected_index',
        index); // Save the selected index to SharedPreferences
    selectedIndex.value = index;

    // Restart the app using Phoenix
    await Get.deleteAll(force: true); //deleting all controllers
    Phoenix.rebirth(Get.context!); // Restarting app
    Get.reset(); // resetting getx
  }
}
