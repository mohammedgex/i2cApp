import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skill_grow/core/colors/app_colors.dart';
import 'package:skill_grow/widgets/controller/textfield_controller.dart';
import '../features/mulit_langual_data/controller/multi_langual_data_controller.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType inputType;
  final String keyName; // Unique key for each text field
  final int minLines;
  final int maxLines;
  final bool? obscureText;
  final String? Function(String?)? validator; // Validator passed here

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.inputType,
    required this.keyName, // Unique key

    this.obscureText = false,
    this.minLines = 1,
    this.maxLines = 1,
    this.validator, // Initialize validator
  });

  @override
  Widget build(BuildContext context) {
    // Get controllers for multi-language and visibility
    final MultiLangualDataController multiLangualDataController =
        Get.put(MultiLangualDataController());
    final TextfieldController textfieldController =
        Get.put(TextfieldController());

    // Translated text for multi-language support
    String translatedText =
        multiLangualDataController.multiLangualData[hint] ?? hint;

    return Obx(() {
      bool isObscure = textfieldController
          .getVisibility(keyName); // Get visibility state for this field

      return Directionality(
        textDirection: TextDirection.rtl,
        child: TextFormField(
          textDirection: TextDirection.rtl,
          obscureText: obscureText == false ? false : isObscure,
          minLines: minLines,
          maxLines: maxLines,
          validator: validator, // Use validator if provided
          decoration: InputDecoration(
            suffixIcon: obscureText == false
                ? null
                : IconButton(
                    icon: Icon(
                      isObscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () {
                      // Toggle visibility for this specific TextField
                      textfieldController.toggle(keyName);
                    },
                  ),
            hintTextDirection: TextDirection.rtl,
            hintText: translatedText,
            hintStyle: TextStyle(
              color: AppColors.hintTextColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
            filled: true,
            fillColor: AppColors.cardBackgroundColor,
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.textFieldBorderColor,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10.sp),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.textFieldBorderColor,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10.sp),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.primaryColor,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(10.sp),
            ),
            contentPadding:
                EdgeInsets.symmetric(vertical: 13.sp, horizontal: 14.sp),
          ),
          controller: controller,
          keyboardType: inputType,
        ),
      );
    });
  }
}
