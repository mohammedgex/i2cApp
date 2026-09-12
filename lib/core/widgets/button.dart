import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skill_grow/core/colors/app_colors.dart';
import 'package:skill_grow/core/widgets/texts.dart';
import 'package:skill_grow/features/mulit_langual_data/controller/multi_langual_data_controller.dart';

class GlobalButton extends StatelessWidget {
  final double height;
  final double width;
  final String text;
  final VoidCallback onTap;
  final Color? color;
  const GlobalButton(
      {super.key,
      required this.height,
      required this.width,
      required this.text,
      required this.onTap,
      this.color});

  @override
  Widget build(BuildContext context) {
    MultiLangualDataController multiLangualDataController =
        Get.put(MultiLangualDataController());
    String translatedText =
        multiLangualDataController.multiLangualData[text] ?? text;
    return Bounceable(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: color ?? AppColors.primaryColor,
          borderRadius: BorderRadius.circular(10.sp),
        ),
        child: Center(
          child: GlobalText(
            softWrap: true,
            text: translatedText,
            style: TextStyle(
              color: AppColors.globalButtonTextColor,
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}
