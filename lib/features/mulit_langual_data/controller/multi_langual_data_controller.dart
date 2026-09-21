import 'package:get/get.dart';
import 'package:skill_grow/features/mulit_langual_data/service/multi_langual_data_service.dart';

class MultiLangualDataController extends GetxController {
  MultiLangualDataService languageService = MultiLangualDataService();
  RxMap<String, dynamic> multiLangualData = <String, dynamic>{}.obs;
  RxBool isLoading = false.obs;
  RxBool isLTR = false.obs;

  @override
  void onInit() async {
    // The product is Arabic-first: keep all layouts and content RTL.
    isLTR.value = false;
    getMultilangualData('ar');
    super.onInit();
  }

  // Make this method async to handle the API response properly
  Future<void> getMultilangualData(String language_code) async {
    try {
      isLoading.value = true;
      var response = await languageService.getLanguage(language_code);

      // Ensure response is valid before updating state
      multiLangualData.value = response;
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}

MultiLangualDataController multiLangualDataController =
    Get.put(MultiLangualDataController());

String translatedText(String text) {
  return multiLangualDataController.multiLangualData[text] ?? text;
}
