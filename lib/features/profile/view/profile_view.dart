import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skill_grow/core/colors/app_colors.dart';
import 'package:skill_grow/core/constant/constant.dart';
import 'package:skill_grow/core/images/app_image.dart';
import 'package:skill_grow/core/widgets/appbar.dart';
import 'package:skill_grow/features/currency/view/currency_list_view.dart';
import 'package:skill_grow/features/mulit_langual_data/controller/multi_langual_data_controller.dart';
import 'package:skill_grow/features/profile/controller/profile_data_cotroller.dart';
import 'package:skill_grow/features/profile/view/account_setting_landing_view.dart';
import 'package:skill_grow/features/profile/view/faq_view.dart';
import 'package:skill_grow/features/profile/view/privecy_policy_view.dart';
import 'package:skill_grow/features/profile/view/terms_and_condition_view.dart';
import 'package:skill_grow/features/profile/view/widget/logout_popup_menu.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/Global/api_endpoint.dart';
import '../../../core/Global/sharedPref.dart';
import '../../../core/widgets/texts.dart';
import '../../language/view/language_list_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  RxString currencyCode = "".obs;
  RxString language = "".obs;
  // Toggle to show/hide the Language & Currency selection in profile
  final bool showLanguageCurrency = true;

  Future<void> loadPreferences() async {
    try {
      // Fetch preferences using SharedPrefUtil
      currencyCode.value = await SharedPrefUtil.get('currency_code', "ُEGP");
      language.value = await SharedPrefUtil.get('language', "Arabic");

      // Print the fetched values
      print('Currency Code: $currencyCode');
      print('Language: $language');
    } catch (e) {
      // Handle any errors that occur during preference loading
      print('Error loading preferences: $e');
      // Fallback to default values in case of an error
      currencyCode.value = 'EGP';
      language.value = 'Arabic';
    }
  }

  @override
  void initState() {
    loadPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MultiLangualDataController multiLangualDataController =
        Get.put(MultiLangualDataController());
    ProfileDataCotroller profileDataCotroller = Get.put(ProfileDataCotroller());
    return Scaffold(
      body: ColorfulSafeArea(
        bottom: false,
        color: AppColors.scaffoldBackgroundColor,
        child: Obx(() {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                textDirection: multiLangualDataController.isLTR.value
                    ? TextDirection.ltr
                    : TextDirection.rtl,
                children: [
                  MyCustomAppBar(
                    horizontalPadding: 0,
                    verticalPadding: 0.sp,
                    isShowbackButton: false,
                  ),
                  Container(
                    width: double.infinity,
                    height: 164.h,
                    decoration: BoxDecoration(
                      // color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(10.sp),
                    ),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        textDirection: multiLangualDataController.isLTR.value
                            ? TextDirection.ltr
                            : TextDirection.rtl,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: 96.w,
                            height: 96.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primaryColor,
                              image: DecorationImage(
                                  image: profileDataCotroller.userDataResponse
                                              .value?.data.image !=
                                          null
                                      ? NetworkImage(ApiEndpoint.BASE_URL +
                                          profileDataCotroller.userDataResponse
                                              .value!.data.image)
                                      : AssetImage(AppImage.profile),
                                  fit: BoxFit.cover),
                            ),
                          ),
                          verticalGap(8.h),
                          GlobalText(
                            text: profileDataCotroller
                                    .userDataResponse.value?.data.name ??
                                "No data found",
                            style: TextStyle(
                                fontSize: 19.sp, fontWeight: FontWeight.w700),
                            softWrap: true,
                          ),
                          GlobalText(
                            text: profileDataCotroller
                                    .userDataResponse.value?.data.email ??
                                "No data found",
                            style: TextStyle(
                                color: AppColors.smallTextColor,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400),
                            softWrap: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (showLanguageCurrency) ...[
                    verticalGap(22.h),
                    GlobalText(
                      text: "Language and Currency",
                      softWrap: true,
                      style: TextStyle(
                        color: AppColors.titleTextColor,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    verticalGap(8.h),
                    Bounceable(
                      onTap: () {
                        Get.to(() => LanguageListView());
                      },
                      child: Container(
                        width: double.infinity,
                        height: 52.h,
                        decoration: BoxDecoration(
                          color: AppColors.cardBackgroundColor,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: AppColors.textFieldBorderColor),
                        ),
                        child: Row(
                          textDirection: multiLangualDataController.isLTR.value
                              ? TextDirection.ltr
                              : TextDirection.rtl,
                          children: [
                            horizontalGap(10.sp),
                            GlobalText(text: "Language", softWrap: true),
                            horizontalGap(10.sp),
                            Obx(() => Text("( ${language.value} )")),
                            Spacer(),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: AppColors.titleTextColor,
                              size: 15.sp,
                            ),
                            horizontalGap(10.sp),
                          ],
                        ),
                      ),
                    ),
                    verticalGap(8.h),
                    Bounceable(
                      onTap: () {
                        Get.to(() => CurrencyListView());
                      },
                      child: Container(
                        width: double.infinity,
                        height: 52.h,
                        decoration: BoxDecoration(
                          color: AppColors.cardBackgroundColor,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: AppColors.textFieldBorderColor),
                        ),
                        child: Row(
                          textDirection: multiLangualDataController.isLTR.value
                              ? TextDirection.ltr
                              : TextDirection.rtl,
                          children: [
                            horizontalGap(10.sp),
                            GlobalText(text: "Currency", softWrap: true),
                            horizontalGap(10.sp),
                            Obx(() => Text("( ${currencyCode.value} )")),
                            Spacer(),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: AppColors.titleTextColor,
                              size: 15.sp,
                            ),
                            horizontalGap(10.sp),
                          ],
                        ),
                      ),
                    ),
                    verticalGap(20.sp),
                  ],
                  GlobalText(text: "Account", softWrap: true),
                  verticalGap(10.sp),
                  Bounceable(
                    onTap: () {
                      Get.to(() => AccountSettingLandingView());
                    },
                    child: Container(
                      width: double.infinity,
                      height: 52.h,
                      decoration: BoxDecoration(
                        color: AppColors.cardBackgroundColor,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: AppColors.textFieldBorderColor),
                      ),
                      child: Row(
                        textDirection: multiLangualDataController.isLTR.value
                            ? TextDirection.ltr
                            : TextDirection.rtl,
                        children: [
                          horizontalGap(10.sp),
                          GlobalText(text: "اعدادات الحساب", softWrap: true),
                          Spacer(),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: AppColors.titleTextColor,
                            size: 15.sp,
                          ),
                          horizontalGap(10.sp),
                        ],
                      ),
                    ),
                  ),
                  verticalGap(20.sp),
                  GlobalText(text: "Help and Support", softWrap: true),
                  verticalGap(10.sp),
                  Bounceable(
                    onTap: () {
                      launchUrl(Uri.parse("${ApiEndpoint.BASE_URL}about-us"));
                    },
                    child: Container(
                      width: double.infinity,
                      height: 52.h,
                      decoration: BoxDecoration(
                        color: AppColors.cardBackgroundColor,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: AppColors.textFieldBorderColor),
                      ),
                      child: Row(
                        textDirection: multiLangualDataController.isLTR.value
                            ? TextDirection.ltr
                            : TextDirection.rtl,
                        children: [
                          horizontalGap(10.sp),
                          GlobalText(text: "معلومات عنا", softWrap: true),
                          Spacer(),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: AppColors.titleTextColor,
                            size: 15.sp,
                          ),
                          horizontalGap(10.sp),
                        ],
                      ),
                    ),
                  ),
                  verticalGap(10.sp),
                  Bounceable(
                    onTap: () {
                      Get.to(() => FAQView());
                    },
                    child: Container(
                      width: double.infinity,
                      height: 52.h,
                      decoration: BoxDecoration(
                        color: AppColors.cardBackgroundColor,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: AppColors.textFieldBorderColor),
                      ),
                      child: Row(
                        textDirection: multiLangualDataController.isLTR.value
                            ? TextDirection.ltr
                            : TextDirection.rtl,
                        children: [
                          horizontalGap(10.sp),
                          GlobalText(
                              text: "Frequently Asked Questions",
                              softWrap: true),
                          Spacer(),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: AppColors.titleTextColor,
                            size: 15.sp,
                          ),
                          horizontalGap(10.sp),
                        ],
                      ),
                    ),
                  ),
                  verticalGap(10.sp),
                  Bounceable(
                    onTap: () {
                      Get.to(() => TermsAndConditionView());
                    },
                    child: Container(
                      width: double.infinity,
                      height: 52.h,
                      decoration: BoxDecoration(
                        color: AppColors.cardBackgroundColor,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: AppColors.textFieldBorderColor),
                      ),
                      child: Row(
                        textDirection: multiLangualDataController.isLTR.value
                            ? TextDirection.ltr
                            : TextDirection.rtl,
                        children: [
                          horizontalGap(10.sp),
                          GlobalText(
                              text: "Terms and Conditions", softWrap: true),
                          Spacer(),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: AppColors.titleTextColor,
                            size: 15.sp,
                          ),
                          horizontalGap(10.sp),
                        ],
                      ),
                    ),
                  ),
                  verticalGap(10.sp),
                  Bounceable(
                    onTap: () {
                      Get.to(() => PrivecyPolicyView());
                    },
                    child: Container(
                      width: double.infinity,
                      height: 52.h,
                      decoration: BoxDecoration(
                        color: AppColors.cardBackgroundColor,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: AppColors.textFieldBorderColor),
                      ),
                      child: Row(
                        textDirection: multiLangualDataController.isLTR.value
                            ? TextDirection.ltr
                            : TextDirection.rtl,
                        children: [
                          horizontalGap(10.sp),
                          GlobalText(text: "Privacy Policy", softWrap: true),
                          Spacer(),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: AppColors.titleTextColor,
                            size: 15.sp,
                          ),
                          horizontalGap(10.sp),
                        ],
                      ),
                    ),
                  ),
                  verticalGap(10.sp),
                  verticalGap(10.sp),
                  Bounceable(
                    onTap: () {
                      showLogoutDialog(context, false);
                    },
                    child: Container(
                      width: double.infinity,
                      height: 52.h,
                      decoration: BoxDecoration(
                        color: AppColors.cardBackgroundColor,
                        border: Border.all(
                            color: AppColors.mainRedColor, width: 0.5.sp),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        textDirection: multiLangualDataController.isLTR.value
                            ? TextDirection.ltr
                            : TextDirection.rtl,
                        children: [
                          horizontalGap(10.sp),
                          GlobalText(
                            text: "Logout",
                            softWrap: true,
                            style: TextStyle(color: AppColors.mainRedColor),
                          ),
                          Spacer(),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: AppColors.mainRedColor,
                            size: 15.sp,
                          ),
                          horizontalGap(10.sp),
                        ],
                      ),
                    ),
                  ),
                  verticalGap(10.sp),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
