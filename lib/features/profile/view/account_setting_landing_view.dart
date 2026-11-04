import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:skill_grow/core/Global/api_endpoint.dart';
import 'package:skill_grow/core/colors/app_colors.dart';
import 'package:skill_grow/core/constant/constant.dart';
import 'package:skill_grow/core/icons/app_icon.dart';
import 'package:skill_grow/core/utils/price_access_helper.dart';
import 'package:skill_grow/core/widgets/snackbar.dart';
import 'package:skill_grow/core/widgets/texts.dart';
import 'package:skill_grow/features/mulit_langual_data/controller/multi_langual_data_controller.dart';
import 'package:skill_grow/features/profile/controller/profile_data_cotroller.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controller/image_picker_controller.dart';
import 'edit_option_button_list_view.dart';

class AccountSettingLandingView extends StatelessWidget {
  final MultiLangualDataController multiLangualDataController =
      Get.put(MultiLangualDataController());
  final ProfileDataCotroller profileDataCotroller =
      Get.put(ProfileDataCotroller());
  final ImagePickerController imagePickerController =
      Get.put(ImagePickerController());

  AccountSettingLandingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
            ),
          ),
          SafeArea(
            bottom: false,
            child: Column(
              textDirection: multiLangualDataController.isLTR.value
                  ? TextDirection.ltr
                  : TextDirection.rtl,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: 15.sp,
                    right: 15.sp,
                    top: 15.sp,
                  ),
                  child: Row(
                    textDirection: multiLangualDataController.isLTR.value
                        ? TextDirection.ltr
                        : TextDirection.rtl,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: SvgPicture.asset(
                          AppIcon.arrowBackIcon,
                          width: 20.sp,
                          color: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Get.to(() => EditOptionButtonListView()),
                        child: const Icon(
                          Icons.edit_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                verticalGap(20.sp),
                GestureDetector(
                  onTap: () => imagePickerController.pickImage(),
                  child: Obx(() => Stack(
                        children: [
                          CircleAvatar(
                            radius: 56.r,
                            foregroundColor: AppColors.primaryColor,
                            backgroundImage:
                                imagePickerController.profileImage.value != null
                                    ? FileImage(imagePickerController
                                        .profileImage.value!) as ImageProvider
                                    : NetworkImage(ApiEndpoint.BASE_URL +
                                        (profileDataCotroller.userDataResponse
                                                .value?.data.image ??
                                            '')) as ImageProvider,
                            backgroundColor: Colors.white,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white),
                              ),
                              child: const Icon(
                                Icons.edit_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
                Obx(() {
                  if (imagePickerController.isImageSelected.value) {
                    if (imagePickerController.isUploading.value) {
                      return Container(
                        margin: EdgeInsets.only(top: 15.sp),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                      );
                    } else {
                      return Bounceable(
                        onTap: () => imagePickerController.uploadImage(),
                        child: Container(
                          margin: EdgeInsets.only(top: 15.sp),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.sp, vertical: 8.sp),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.sp),
                          ),
                          child: GlobalText(
                            text: "Upload",
                            style: TextStyle(color: AppColors.primaryColor),
                          ),
                        ),
                      );
                    }
                  } else {
                    return Container();
                  }
                }),
                verticalGap(12.sp),
                Obx(() => GlobalText(
                      text: profileDataCotroller
                              .userDataResponse.value?.data.name ??
                          'No Name',
                      softWrap: true,
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )),
                Obx(() => GlobalText(
                      text: profileDataCotroller
                              .userDataResponse.value?.data.jobTitle ??
                          'No Job Title',
                      softWrap: true,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    )),
                verticalGap(20.sp),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 16.sp,
                      right: 16.sp,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        )),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          verticalGap(16.sp),
                          Obx(() => _buildInfoRow(
                              Icons.email_outlined,
                              "Email",
                              profileDataCotroller
                                      .userDataResponse.value?.data.email ??
                                  'No Email')),
                          Obx(() => _buildInfoRow(
                              Icons.phone_outlined,
                              "Phone",
                              profileDataCotroller
                                      .userDataResponse.value?.data.phone ??
                                  'No Phone')),
                          Obx(() => _buildInfoRow(
                              Icons.location_city_outlined,
                              "Location",
                              "${profileDataCotroller.userDataResponse.value?.data.city ?? 'No City'}, ${profileDataCotroller.userDataResponse.value?.data.state ?? 'No State'}")),
                          Obx(() => _buildInfoRow(
                              Icons.cake_outlined,
                              "Age",
                              profileDataCotroller
                                      .userDataResponse.value?.data.age
                                      .toString() ??
                                  'No Age')),
                          verticalGap(16.sp),
                          GlobalText(
                            text: "About Me",
                            softWrap: true,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          verticalGap(8.sp),
                          Obx(() => GlobalText(
                                softWrap: true,
                                text: profileDataCotroller
                                        .userDataResponse.value?.data.bio ??
                                    'No Bio Available',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey[700]),
                                textAlign: TextAlign.justify,
                              )),
                          verticalGap(16.sp),
                          Divider(),
                          Obx(() => Column(
                                textDirection:
                                    multiLangualDataController.isLTR.value
                                        ? TextDirection.ltr
                                        : TextDirection.rtl,
                                children: _buildSocialLinks(),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Padding(
      padding: EdgeInsets.only(top: 7.sp),
      child: Row(
        textDirection: multiLangualDataController.isLTR.value
            ? TextDirection.ltr
            : TextDirection.rtl,
        children: [
          Icon(icon, color: AppColors.primaryColor),
          horizontalGap(10.sp),
          Expanded(
            child: GlobalText(
              softWrap: true,
              text: "$title: $value",
              style: TextStyle(
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSocialLinks() {
    if (PriceAccessHelper.shouldHideExternalLinks()) return [];

    final userData = profileDataCotroller.userDataResponse.value?.data;
    if (userData == null) return [];

    List<Map<String, dynamic>> socialLinks = [
      {
        "icon": FontAwesomeIcons.facebook,
        "url": userData.facebook,
        "name": "Facebook"
      },
      {
        "icon": FontAwesomeIcons.linkedinIn,
        "url": userData.linkedin,
        "name": "Linkedin"
      },
      {
        "icon": FontAwesomeIcons.github,
        "url": userData.github,
        "name": "Github"
      },
      {"icon": FontAwesomeIcons.x, "url": userData.twitter, "name": "Twitter"},
      {
        "icon": FontAwesomeIcons.globe,
        "url": userData.website,
        "name": "Website"
      },
    ];

    return socialLinks
        .where((link) => link["url"] != null && link["url"].isNotEmpty)
        .map(
          (link) => Bounceable(
            onTap: () {
              if (link["url"] != null && link["url"].isNotEmpty) {
                launchUrl(
                  Uri.parse(link["url"]),
                  mode: LaunchMode.externalApplication,
                );
              } else {
                customSnackbar(
                    title: "Error",
                    message: "Invalid URL",
                    type: CustomSnackbarType.failed);
              }
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 8.sp),
              padding: EdgeInsets.symmetric(vertical: 15.sp, horizontal: 15.sp),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.sp),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                children: [
                  Icon(link["icon"],
                      size: 20.sp, color: AppColors.primaryColor),
                  horizontalGap(10.sp),
                  Expanded(
                    child: GlobalText(
                      softWrap: true,
                      text: link["name"],
                      style: TextStyle(
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16.sp,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        )
        .toList();
  }
}
