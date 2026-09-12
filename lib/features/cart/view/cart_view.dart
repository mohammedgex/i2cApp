import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:skill_grow/core/Global/api_endpoint.dart';
import 'package:skill_grow/core/colors/app_colors.dart';
import 'package:skill_grow/core/icons/app_icon.dart';
import 'package:skill_grow/core/widgets/appbar.dart';
import 'package:skill_grow/features/cart/controller/cart_list_controller.dart';
import 'package:skill_grow/widgets/custom_slider.dart';
import '../../../core/constant/constant.dart';
import '../../../core/widgets/custom_rating_bar.dart';
import '../../../core/widgets/texts.dart';
import '../../mulit_langual_data/controller/multi_langual_data_controller.dart';
import '../../payment/view/manual_payment_screen.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    MultiLangualDataController multiLangualDataController =
        Get.put(MultiLangualDataController());
    CartListController cartListController = Get.put(CartListController());

    return Obx(() {
      if (cartListController.isLoading.value) {
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else {
        if (cartListController.cartData.value.cartCourses.isEmpty) {
          return Scaffold(
              body: ColorfulSafeArea(
            bottom: false,
            color: AppColors.scaffoldBackgroundColor,
            child: Center(
              child: Column(
                children: [
                  MyCustomAppBar(
                    verticalPadding: 0,
                    horizontalPadding: 15.sp,
                    isShowbackButton: true,
                    isShowNotification: false,
                  ),
                  Spacer(),
                  GlobalText(
                      text: "Your cart is empty",
                      softWrap: true,
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.w600)),
                  Spacer()
                ],
              ),
            ),
          ));
        } else {
          return Scaffold(
            body: ColorfulSafeArea(
              bottom: false,
              color: AppColors.scaffoldBackgroundColor,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  textDirection: multiLangualDataController.isLTR.value
                      ? TextDirection.ltr
                      : TextDirection.rtl,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyCustomAppBar(
                      verticalPadding: 0,
                      horizontalPadding: 0,
                      isShowbackButton: true,
                      isShowNotification: false,
                    ),
                    GlobalText(
                      text: "السلة",
                      softWrap: true,
                      style: TextStyle(
                          fontSize: 19.sp, fontWeight: FontWeight.w700),
                    ),
                    ...cartListController.cartData.value.cartCourses.map(
                      (cart) => Padding(
                        padding: EdgeInsets.only(bottom: 10.sp),
                        child: CustomSlidable(
                          isLoading: cartListController.isDeleting,
                          onDelete: () {
                            cartListController.removeFromCart(cart.slug);
                          },
                          child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14.r),
                                color: AppColors.cardBackgroundColor,
                                border: Border.all(
                                    color: AppColors.textFieldBorderColor),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(8.w),
                                child: Row(
                                  textDirection:
                                      multiLangualDataController.isLTR.value
                                          ? TextDirection.ltr
                                          : TextDirection.rtl,
                                  children: [
                                    Container(
                                      height: 86.h,
                                      width: 112.w,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                      ),
                                      child: Image.network(
                                        ApiEndpoint.BASE_URL + cart.thumbnail,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    horizontalGap(10.sp),
                                    Expanded(
                                      child: Column(
                                        textDirection:
                                            multiLangualDataController
                                                    .isLTR.value
                                                ? TextDirection.ltr
                                                : TextDirection.rtl,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          GlobalText(
                                            text: cart.title,
                                            style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w600,
                                                color:
                                                    AppColors.titleTextColor),
                                            softWrap: true,
                                          ),
                                          verticalGap(3.sp),
                                          Row(
                                            textDirection:
                                                multiLangualDataController
                                                        .isLTR.value
                                                    ? TextDirection.ltr
                                                    : TextDirection.rtl,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            spacing: 5.sp,
                                            children: [
                                              GlobalText(
                                                  text: cart.instructor.name,
                                                  style: TextStyle(
                                                      fontSize: 10.sp,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      color: AppColors
                                                          .titleTextColor),
                                                  softWrap: true),
                                              GlobalText(
                                                  text: "|",
                                                  style: TextStyle(
                                                      fontSize: 10.sp,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      color: AppColors
                                                          .titleTextColor),
                                                  softWrap: true),
                                              Text(cart.students.toString(),
                                                  style: TextStyle(
                                                      fontSize: 10.sp,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      color: AppColors
                                                          .titleTextColor),
                                                  softWrap: true),
                                              GlobalText(
                                                  text: "Students",
                                                  style: TextStyle(
                                                      fontSize: 10.sp,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      color: AppColors
                                                          .titleTextColor),
                                                  softWrap: true),
                                            ],
                                          ),
                                          verticalGap(2.sp),
                                          Row(
                                            textDirection:
                                                multiLangualDataController
                                                        .isLTR.value
                                                    ? TextDirection.ltr
                                                    : TextDirection.rtl,
                                            children: [
                                              CustomRatingBar(
                                                rating: cart.averageRating,
                                                maxRating: 5,
                                                iconSize: 13.sp,
                                                filledColor:
                                                    AppColors.activeIconColor,
                                                unfilledColor:
                                                    AppColors.activeIconColor,
                                              ),
                                              Spacer(),
                                              Row(
                                                textDirection:
                                                    multiLangualDataController
                                                            .isLTR.value
                                                        ? TextDirection.ltr
                                                        : TextDirection.rtl,
                                                children: [
                                                  cart.discount == 0
                                                      ? Container()
                                                      : GlobalText(
                                                          text: cart.discount
                                                              .toString(),
                                                          style: TextStyle(
                                                              decoration:
                                                                  TextDecoration
                                                                      .lineThrough,
                                                              fontSize: 10.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: AppColors
                                                                  .titleTextColor),
                                                          softWrap: true,
                                                        ),
                                                  horizontalGap(3.sp),
                                                  GlobalText(
                                                    text: cart.price.toString(),
                                                    style: TextStyle(
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: AppColors
                                                            .titleTextColor),
                                                    softWrap: true,
                                                  ),
                                                  horizontalGap(5.sp),
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Container(
              margin: EdgeInsets.zero,
              width: double.infinity,
              height: 78.h,
              decoration: BoxDecoration(
                color: AppColors.cardBackgroundColor,
                border: Border(
                  top: BorderSide(color: AppColors.textFieldBorderColor),
                ),
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                  textDirection: multiLangualDataController.isLTR.value
                      ? TextDirection.ltr
                      : TextDirection.rtl,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: GlobalText(
                      text: "الإجمالي الفرعي",
                      softWrap: true,
                      style: TextStyle(
                        color: AppColors.smallTextColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp,
                      ),
                    )),
                    GlobalText(
                      text: cartListController.cartData.value.totalAmount.toString(),
                      softWrap: false,
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16.sp),
                    ),
                    horizontalGap(14.w),
                    Bounceable(
                      onTap: () {
                        Get.to(() => const ManualPaymentScreen());
                      },
                      child: Container(
                        height: 46.h,
                        width: 132.w,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Center(
                          child: Row(
                            textDirection:
                                multiLangualDataController.isLTR.value
                                    ? TextDirection.ltr
                                    : TextDirection.rtl,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GlobalText(
                                text: "الدفع",
                                softWrap: true,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              horizontalGap(5.w),
                              SizedBox(
                                  width: 14.sp,
                                  child: SvgPicture.asset(
                                      AppIcon.arrowForwardIcon))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
            ),
          );
        }
      }
    });
  }
}
