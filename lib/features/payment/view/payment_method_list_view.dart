import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skill_grow/core/widgets/appbar.dart';
import 'package:skill_grow/features/mulit_langual_data/controller/multi_langual_data_controller.dart';
import 'package:skill_grow/features/payment/controller/payment_method_list_controller.dart';
import '../../../core/colors/app_colors.dart';
import '../../../core/constant/constant.dart';
import '../../../core/widgets/texts.dart';
import '../controller/payment_url_controller.dart';
import '../model/payment_method_list_model.dart';

class PaymentMethodListView extends StatelessWidget {
  const PaymentMethodListView({super.key});

  @override
  Widget build(BuildContext context) {
    final MultiLangualDataController multiLangualDataController =
        Get.put(MultiLangualDataController());
    final PaymentMethodsController paymentMethodsController =
        Get.put(PaymentMethodsController());
    final PaymentUrlController paymentUrlController =
        Get.put(PaymentUrlController());

    return Scaffold(
      body: ColorfulSafeArea(
        bottom: false,
        color: AppColors.scaffoldBackgroundColor,
        child: Obx(() {
          if (paymentMethodsController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (paymentMethodsController.paymentMethods.isEmpty) {
            return const Center(child: Text("No payment methods available"));
          } else {
            return _buildPaymentMethodList(
                multiLangualDataController, paymentMethodsController, paymentUrlController);
          }
        }),
      ),
    );
  }

  Widget _buildPaymentMethodList(
    MultiLangualDataController multiLangualDataController,
    PaymentMethodsController paymentMethodsController,
    PaymentUrlController paymentUrlController,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          textDirection: multiLangualDataController.isLTR.value
              ? TextDirection.ltr
              : TextDirection.rtl,
          children: [
            MyCustomAppBar(
              verticalPadding: 0,
              horizontalPadding: 0,
              isShowbackButton: true,
            ),
            verticalGap(8.h),
            GlobalText(
              text: "Payment Methods",
              softWrap: true,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.titleTextColor,
              ),
            ),
            verticalGap(10.sp),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: paymentMethodsController.paymentMethods.length,
              itemBuilder: (context, index) {
                final PaymentMethod method =
                    paymentMethodsController.paymentMethods[index];
                return _buildPaymentMethodItem(
                    method, multiLangualDataController, paymentUrlController);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodItem(
    PaymentMethod method,
    MultiLangualDataController multiLangualDataController,
    PaymentUrlController paymentUrlController,
  ) {
    return Bounceable(
      onTap: () {
        paymentUrlController.initiatePayment(method.key);
        print("Selected payment method: ${method.key}");
      },
      child: Obx(() {
        final bool isLoading =
            paymentUrlController.isLoading(method.key);

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(12.w),
          margin: EdgeInsets.only(bottom: 8.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: AppColors.cardBackgroundColor,
            border: Border.all(color: AppColors.textFieldBorderColor),
          ),
          child: Row(
            textDirection: multiLangualDataController.isLTR.value
                ? TextDirection.ltr
                : TextDirection.rtl,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.network(
                  method.logo,
                  height: 44.h,
                  width: 88.w,
                ),
              ),
              horizontalGap(10.sp),
              GlobalText(
                text: method.name,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.titleTextColor,
                ),
                softWrap: true,
              ),
              const Spacer(),
              isLoading
                  ? CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    )
                  : Icon(
                      Icons.arrow_forward_ios,
                      size: 15.sp,
                      color: AppColors.titleTextColor,
                    ),
            ],
          ),
        );
      }),
    );
  }
}
