import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skill_grow/core/Global/sharedPref.dart';
import 'package:skill_grow/features/authentication/view/login_view.dart';
import 'package:skill_grow/features/onboarding/model/onboarding_model.dart';

class OnboardingController extends GetxController {
  Rx<OnboardingModel?> welcomeData = Rx<OnboardingModel?>(null);
  RxBool isLoading = true.obs;
  RxInt currentPage = 0.obs;
  PageController pageController = PageController();

  @override
  void onInit() {
    fetchOnboardingData();
    super.onInit();
  }

  void fetchOnboardingData() {
    isLoading.value = true;
    welcomeData.value = OnboardingModel(
      status: 'success',
      data: [
        WelcomeData(
          title: 'انطلق في عالم صيانة الموبايل',
          description:
              'دروس عملية وتطبيقية تأخذك من المستوى المبتدئ إلى الاحتراف خطوة بخطوة.',
        ),
        WelcomeData(
          title: 'مرونة كاملة في التعلم',
          description:
              'شاهد المحاضرات في أي وقت ومن أي مكان، مع إمكانية متابعة تقدمك الدراسي بسهولة.',
        ),
        WelcomeData(
          title: 'ابدأ مسارك المهني بثقة',
          description:
              'اكتسب المهارات المطلوبة فعلياً في سوق العمل وافتح لنفسك فرصاً للاستقلال المالي.',
        ),
      ],
    );
    isLoading.value = false;
  }

  void nextPage() {
    if (currentPage.value < welcomeData.value!.data.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      SharedPrefUtil.put("isFirstTime", false);
      // Navigate to home or login screen
      Get.offAll(() => LoginView());
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}
