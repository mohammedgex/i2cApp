import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skill_grow/core/Global/sharedPref.dart';
import 'package:skill_grow/core/services/fcm_token_service.dart';
import 'package:skill_grow/core/services/push_notifications_service.dart';
import 'package:skill_grow/features/authentication/service/login_service.dart';
import 'package:skill_grow/features/mulit_langual_data/controller/multi_langual_data_controller.dart';
import 'package:skill_grow/features/navigation_bar/views/bottom_navigation_bar.dart';

import '../../../core/widgets/snackbar.dart';
import '../model/login_model.dart';

class LoginController extends GetxController {
  // Form key
  final formKey = GlobalKey<FormState>();

  // Text controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // State management
  var isLoading = false.obs;

  // Email validation
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    String pattern = r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,7}\b';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return translatedText('Please enter a valid email address');
    }
    return null;
  }

  // Password validation
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return translatedText('Please enter your password');
    }
    if (value.length < 4) {
      return translatedText('Password must be at least 4 characters long');
    }
    return null;
  }

  // Login function
  Future<void> login() async {
    isLoading.value = true;
    try {
      final requestModel = LoginRequestModel(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final response = await LoginService().login(requestModel);

      if (response.status == 'success') {
        await SharedPrefUtil.put('token', response.bearerToken);
        await SharedPrefUtil.put('isLoggedin', true);

        await PushNotificationsService.instance.init(force: true);
        await FcmTokenService.updateFcmToken();

        customSnackbar(
          title: "Success",
          message: response.message.toString(),
          type: CustomSnackbarType.success,
        );

        Get.offAll(() => CustomPersistentBottomNavBar());
        emailController.clear();
        passwordController.clear();
        return;
      }

      customSnackbar(
        title: "Error",
        message: response.message.toString(),
        type: CustomSnackbarType.failed,
      );
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
