import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skill_grow/core/colors/app_colors.dart';
import 'package:skill_grow/core/constant/constant.dart';
import 'package:skill_grow/core/images/app_image.dart';
import 'package:skill_grow/core/widgets/button.dart';
import 'package:skill_grow/core/widgets/texts.dart';
import 'package:skill_grow/features/authentication/controller/login_controller.dart';
import 'package:skill_grow/features/authentication/view/forget_password_view.dart';
import 'package:skill_grow/features/authentication/view/registration_view.dart';
import 'package:skill_grow/widgets/text_input.dart';
import '../../mulit_langual_data/controller/multi_langual_data_controller.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final MultiLangualDataController multiLangualDataController =
      Get.put(MultiLangualDataController());

  final LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ColorfulSafeArea(
        bottom: false,
        color: AppColors.scaffoldBackgroundColor,
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Form(
              key: loginController.formKey,
              child: SingleChildScrollView(
                child: Column(
                  textDirection: multiLangualDataController.isLTR.value
                      ? TextDirection.ltr
                      : TextDirection.rtl,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20.h),
                    Image.asset(
                      AppImage.logo,
                      height: 100.sp,
                      width: 150.sp,
                    ),
                    verticalGap(24.h),
                    Align(
                      alignment: multiLangualDataController.isLTR.value
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: GlobalText(
                        text: ' مرحبا بك في i2C Academy',
                        softWrap: true,
                        style: TextStyle(
                          color: AppColors.titleTextColor,
                          fontSize: 23.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    verticalGap(4.h),
                    Align(
                      alignment: multiLangualDataController.isLTR.value
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: GlobalText(
                        text:
                            'سجل دخولك لتتابع دوراتك وتطور مهاراتك في صيانة الموبايل.',
                        softWrap: true,
                        style: TextStyle(
                          color: AppColors.smallTextColor,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    verticalGap(22.h),
                    CustomTextField(
                      controller: loginController.emailController,
                      hint: "Email",
                      keyName: "Email",
                      inputType: TextInputType.emailAddress,
                      validator: loginController.validateEmail,
                    ),
                    verticalGap(12.sp),
                    CustomTextField(
                      controller: loginController.passwordController,
                      obscureText: true,
                      hint: "Password",
                      keyName: "Password",
                      inputType: TextInputType.visiblePassword,
                      validator: loginController.validatePassword,
                    ),
                    verticalGap(12.sp),
                    Align(
                        alignment: Alignment.centerRight,
                        child: Bounceable(
                          onTap: () {
                            Get.to(() => const ForgetPasswordView());
                            // Get.off(() => const ResetPasswordInfoView());
                          },
                          child: GlobalText(
                            text: "Forgot Password?",
                            softWrap: true,
                            style: TextStyle(color: AppColors.primaryColor),
                          ),
                        )),
                    verticalGap(18.sp),
                    Obx(() {
                      if (loginController.isLoading.value) {
                        return Center(
                          child: Container(
                            padding: EdgeInsets.all(5.sp),
                            height: 46.sp,
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
                          height: 46.sp,
                          text: "Login",
                          onTap: () {
                            if (loginController.formKey.currentState!
                                .validate()) {
                              loginController.login();
                            }
                          },
                        );
                      }
                    }),
                    verticalGap(8.sp),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      textDirection: multiLangualDataController.isLTR.value
                          ? TextDirection.ltr
                          : TextDirection.rtl,
                      children: [
                        Flexible(
                          child: GlobalText(
                            text: "Dont have an account?",
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(fontSize: 13.sp),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.to(() => const RegistrationView());
                          },
                          child: GlobalText(
                            text: "Register",
                            softWrap: true,
                            style: TextStyle(
                                fontSize: 13.sp, color: AppColors.primaryColor),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
