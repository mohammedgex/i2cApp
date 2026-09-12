import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skill_grow/core/colors/app_colors.dart';
import 'package:skill_grow/core/constant/constant.dart';
import 'package:skill_grow/core/images/app_image.dart';
import 'package:skill_grow/features/onboarding/controller/onboarding_controller.dart';

class OnboardingView extends StatelessWidget {
  final OnboardingController controller = Get.find<OnboardingController>();

  OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          // Force RTL for onboarding page and use Arabic labels
          final onboardingData = controller.welcomeData.value!.data;
          final isLastPage =
              controller.currentPage.value == onboardingData.length - 1;

          return Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: controller.pageController,
                    onPageChanged: (index) {
                      controller.currentPage.value = index;
                    },
                    itemCount: controller.welcomeData.value!.data.length,
                    itemBuilder: (context, index) {
                      final item = controller.welcomeData.value!.data[index];

                      // Loop through images dynamically
                      List<String> onboardingImages = [
                        AppImage.onboardingImage1,
                        AppImage.onboardingImage2,
                        AppImage.onboardingImage3
                      ];
                      String image =
                          onboardingImages[index % onboardingImages.length];

                      return LayoutBuilder(
                        builder: (context, constraints) {
                          return SingleChildScrollView(
                            padding: EdgeInsets.symmetric(vertical: 24.h),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: constraints.maxHeight,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    image,
                                    width: 400.w,
                                    height: 280.h,
                                  ),
                                  verticalGap(26.h),
                                  SizedBox(
                                    width: double.infinity,
                                    child: Text(
                                      item.title,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 24.sp,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.titleTextColor,
                                        height: 1.3,
                                      ),
                                    ),
                                  ),
                                  verticalGap(14.h),
                                  SizedBox(
                                    width: double.infinity,
                                    child: Text(
                                      item.description,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color: AppColors.smallTextColor,
                                        height: 1.5,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                verticalGap(32.h),

                // Page Indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    controller.welcomeData.value!.data.length,
                    (index) => AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: 5.w),
                      width: controller.currentPage.value == index ? 24.w : 8.w,
                      height: 8.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.h),
                        color: controller.currentPage.value == index
                            ? AppColors.primaryColor
                            : Colors.grey.shade300,
                      ),
                    ),
                  ),
                ),
                verticalGap(20.h),

                // Navigation Buttons
                Row(
                  // ensure buttons layout matches RTL
                  textDirection: TextDirection.rtl,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Visibility(
                      visible: controller.currentPage.value > 0,
                      child: Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.cardBackgroundColor,
                            borderRadius: BorderRadius.circular(14.r),
                            border: Border.all(
                              color: AppColors.textFieldBorderColor,
                              width: 1.5,
                            ),
                          ),
                          child: ElevatedButton(
                            onPressed: controller.previousPage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.h, horizontal: 16.w),
                            ),
                            child: Text(
                              "السابق",
                              style: TextStyle(
                                fontFamily: 'BalooBhaijaan2',
                                fontSize: 16.sp,
                                color: AppColors.titleTextColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (controller.currentPage.value > 0) horizontalGap(20.w),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: ElevatedButton(
                          onPressed: controller.nextPage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 8.h, horizontal: 16.w),
                          ),
                          child: Text(
                            isLastPage ? "ابدأ الآن" : "التالي",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontFamily: 'BalooBhaijaan2',
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                verticalGap(30.h),
              ],
            ), // end Column
          ); // end Directionality (returned)
        }),
      ),
    );
  }
}
