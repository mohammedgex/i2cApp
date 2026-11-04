import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:skill_grow/core/colors/app_colors.dart';
import 'package:skill_grow/core/icons/app_icon.dart';
import 'package:skill_grow/core/widgets/texts.dart';
import 'package:skill_grow/features/mulit_langual_data/controller/multi_langual_data_controller.dart';

import '../constant/constant.dart';

// Enum to define Snackbar Types

customSnackbar(
    {required String title,
    required String message,
    required CustomSnackbarType type}) {
  ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
    content: CustomSnackbarContent(
      title: title,
      message: message,
      type: type,
    ),
    elevation: 0,
    backgroundColor:
        Colors.transparent, // Makes the Snackbar background transparent
    behavior: SnackBarBehavior
        .floating, // Optional: to make the snackbar float on top
    duration:
        Duration(seconds: 3), // Optional: set the duration for the snackbar
  ));
}

enum CustomSnackbarType { success, warning, info, failed }

class CustomSnackbarContent extends StatelessWidget {
  const CustomSnackbarContent({
    super.key,
    required this.title,
    required this.message,
    required this.type,
  });

  final String title;
  final String message;
  final CustomSnackbarType type;

  @override
  Widget build(BuildContext context) {
    MultiLangualDataController multiLangualDataController =
        Get.put(MultiLangualDataController());

    // Define Colors and Icons based on Type
    Color backgroundColor;
    String iconPath;
    Color iconBackgroundColor;
    String titleText;
    String messageText;

    switch (type) {
      case CustomSnackbarType.success:
        backgroundColor = AppColors.successSnackBackgroundColor;
        iconPath = AppIcon.successIcon;
        iconBackgroundColor = AppColors.successSnackIconBackgroundColor;
        titleText = title;
        messageText = message;
        break;
      case CustomSnackbarType.failed:
        backgroundColor = AppColors.failedSnackBackgroundColor;
        iconPath = AppIcon.failedIcon;
        iconBackgroundColor = AppColors.failedSnackIconBackgroundColor;
        titleText = title;
        messageText = message;
        break;
      case CustomSnackbarType.info:
        backgroundColor = AppColors.infoSnackBackgroundColor;
        iconPath = AppIcon.infoIcon;
        iconBackgroundColor = AppColors.infoSnackIconBackgroundColor;
        titleText = title;
        messageText = message;
        break;

      case CustomSnackbarType.warning:
        backgroundColor = AppColors.warningSnackBackgroundColor;
        iconPath = AppIcon.failedIcon;
        iconBackgroundColor = AppColors.warningSnackIconBackgroundColor;
        titleText = title;
        messageText = message;
        break;
    }

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: 100.sp),
      padding: EdgeInsets.symmetric(vertical: 16.sp, horizontal: 16.sp),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10.sp),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        textDirection: multiLangualDataController.isLTR.value
            ? TextDirection.ltr
            : TextDirection.rtl,
        children: [
          Container(
            height: 30.sp,
            width: 30.sp,
            padding: EdgeInsets.all(5.sp),
            decoration: BoxDecoration(
                color: iconBackgroundColor, shape: BoxShape.circle),
            child: SvgPicture.asset(
              iconPath,
            ),
          ),
          horizontalGap(15.sp),
          Expanded(
            child: Column(
              textDirection: multiLangualDataController.isLTR.value
                  ? TextDirection.ltr
                  : TextDirection.rtl,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GlobalText(
                  text: titleText,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15.sp,
                      color: AppColors.titleTextColor),
                  softWrap: true,
                ),
                verticalGap(5.sp),
                GlobalText(
                  text: messageText,
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                      color: AppColors.titleTextColor),
                  softWrap: true,
                ),
              ],
            ),
          ),
          horizontalGap(15.sp),
          Bounceable(
              onTap: () {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
              },
              child: SvgPicture.asset(
                AppIcon.crossIcon,
                color: AppColors.inactiveIconColor,
              )),
        ],
      ),
    );
  }
}
