import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skill_grow/core/colors/app_colors.dart';
import 'package:skill_grow/core/constant/constant.dart';
import 'package:skill_grow/core/images/app_image.dart';
import 'package:skill_grow/core/widgets/button.dart';
import 'package:skill_grow/core/widgets/texts.dart';
import 'package:skill_grow/features/authentication/controller/registration_controller.dart';
import 'package:skill_grow/widgets/text_input.dart';
import '../../mulit_langual_data/controller/multi_langual_data_controller.dart';

class RegistrationView extends StatelessWidget {
  const RegistrationView({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller instance

    MultiLangualDataController multiLangualDataController =
        Get.put(MultiLangualDataController());

    RegistrationController registrationController =
        Get.put(RegistrationController());

    return Scaffold(
      body: Obx(() {
        return Center(
          child: Padding(
            padding: EdgeInsets.all(18.0),
            child: Form(
              key: registrationController
                  .formKey, // Form key to handle validation
              child: SingleChildScrollView(
                child: Column(
                  textDirection: multiLangualDataController.isLTR.value
                      ? TextDirection.ltr
                      : TextDirection.rtl,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppImage.logo,
                      height: 110.sp,
                      width: 165.sp,
                    ),
                    CustomTextField(
                      controller: registrationController.nameController,
                      hint: "Name",
                      keyName: "Name",
                      inputType: TextInputType.name,
                      validator: (value) {
                        return value == null || value.isEmpty
                            ? 'Please enter your name'
                            : null;
                      },
                    ),
                    verticalGap(10.sp),
                    CustomTextField(
                      controller: registrationController.emailController,
                      hint: "Email",
                      keyName: "Email",
                      inputType: TextInputType.emailAddress,
                      validator: registrationController.validateEmail,
                    ),
                    verticalGap(10.sp),
                    CustomTextField(
                      controller: registrationController.passwordController,
                      hint: "Password",
                      keyName: "Password",
                      obscureText: true,
                      inputType: TextInputType.visiblePassword,
                      validator: (value) =>
                          registrationController.validatePassword(value),
                    ),
                    verticalGap(10.sp),
                    CustomTextField(
                      controller:
                          registrationController.confirmPasswordController,
                      hint: "Confirm Password",
                      keyName: "Confirm Password",
                      inputType: TextInputType.visiblePassword,
                      obscureText: true,
                      validator: registrationController.validateConfirmPassword,
                    ),
                    verticalGap(10.sp),
                    Obx(() {
                      if (registrationController.isLoading.value) {
                        return Center(
                          child: Container(
                            padding: EdgeInsets.all(5.sp),
                            height: 50.sp,
                            width: 50.sp,
                            child: CircularProgressIndicator(
                              color: AppColors.primaryColor,
                              // valueColor: AppColors.primaryColor as Colors,
                            ),
                          ),
                        );
                      } else {
                        return GlobalButton(
                          width: double.infinity,
                          height: 50.sp,
                          text: "Register",
                          onTap: () {
                            if (registrationController.formKey.currentState!
                                .validate()) {
                              registrationController.register();
                            }
                          },
                        );
                      }
                    }),
                    verticalGap(5.sp),
                    Row(
                      textDirection: multiLangualDataController.isLTR.value
                          ? TextDirection.ltr
                          : TextDirection.rtl,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GlobalText(
                          text: "Already have an account?",
                          softWrap: true,
                          style: TextStyle(fontSize: 13.sp),
                        ),
                        TextButton(
                          style: ButtonStyle(
                            foregroundColor: WidgetStateProperty.all<Color>(
                              AppColors.primaryColor,
                            ),
                            backgroundColor: WidgetStateProperty.all<Color>(
                                Colors.transparent),
                          ),
                          onPressed: () {
                            Get.back();
                          },
                          child: GlobalText(
                            text: "Login",
                            softWrap: true,
                            style: TextStyle(fontSize: 13.sp),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
