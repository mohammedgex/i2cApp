import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skill_grow/core/Global/api_endpoint.dart';
import 'package:skill_grow/core/utils/price_access_helper.dart';
import 'package:skill_grow/core/widgets/appbar.dart';
import 'package:skill_grow/core/widgets/custom_rating_bar.dart';
import 'package:skill_grow/features/course/controller/wish_list_controller.dart';
import 'package:skill_grow/features/learining/widget/ernrollerd_course_loaing_ui.dart';
import 'package:skill_grow/widgets/custom_slider.dart';
import '../../../core/colors/app_colors.dart';
import '../../../core/constant/constant.dart';
import '../../../core/widgets/texts.dart';
import '../../mulit_langual_data/controller/multi_langual_data_controller.dart';

class WishListView extends StatelessWidget {
  const WishListView({super.key});

  @override
  Widget build(BuildContext context) {
    MultiLangualDataController multiLangualDataController =
        Get.put(MultiLangualDataController());
    WishListController wishListController = Get.put(WishListController());
    return Scaffold(
      body: Obx(() {
        if (wishListController.isLoading.value) {
          return const Center(child: ErnrollerdCourseLoaingUi());
        } else {
          if (wishListController.wishList.isEmpty) {
            return ColorfulSafeArea(
              color: AppColors.scaffoldBackgroundColor,
              child: Column(
                children: [
                  MyCustomAppBar(
                    verticalPadding: 0,
                    horizontalPadding: 10.sp,
                    isShowbackButton: true,
                    isShowNotification: false,
                  ),
                  Spacer(),
                  Center(
                    child: GlobalText(
                      text: "No Data Found",
                      softWrap: true,
                    ),
                  ),
                  Spacer(),
                ],
              ),
            );
          } else {
            return ColorfulSafeArea(
              bottom: false,
              color: AppColors.scaffoldBackgroundColor,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
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
                      text: "Wish List",
                      softWrap: true,
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.w600),
                    ),
                    ...wishListController.wishList.value.map(
                      (wishItem) => Padding(
                        padding: EdgeInsets.only(bottom: 10.sp),
                        child: CustomSlidable(
                          isLoading: wishListController.isDeleting,
                          onDelete: () {
                            wishListController
                                .removeFromWishlist(wishItem.slug);
                          },
                          child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                // border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10.sp),
                                color: AppColors.nuralItemBackgroundColor,
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(3.sp),
                                child: Row(
                                  textDirection:
                                      multiLangualDataController.isLTR.value
                                          ? TextDirection.ltr
                                          : TextDirection.rtl,
                                  children: [
                                    Container(
                                      height: 80.sp,
                                      width: 103.sp,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.sp),
                                      ),
                                      child: Image.network(
                                        ApiEndpoint.BASE_URL +
                                            wishItem.thumbnail,
                                        // fit: BoxFit.cover,
                                      ),
                                    ),
                                    horizontalGap(10.sp),
                                    SizedBox(
                                      width: 235.w,
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
                                            text: wishItem.title,
                                            style: TextStyle(
                                                fontSize: 12.sp,
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
                                                  text:
                                                      wishItem.instructor.name,
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
                                              Text(wishItem.students.toString(),
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
                                                rating: wishItem.averageRating
                                                    .toDouble(),
                                                maxRating: 5,
                                                iconSize: 15.sp,
                                                filledColor:
                                                    AppColors.activeIconColor,
                                                unfilledColor:
                                                    AppColors.activeIconColor,
                                              ),
                                              Spacer(),
                                              PriceAccessHelper
                                                  .hideCommercialContent(
                                                Row(
                                                  textDirection:
                                                      multiLangualDataController
                                                              .isLTR.value
                                                          ? TextDirection.ltr
                                                          : TextDirection.rtl,
                                                  children: [
                                                    if (!PriceAccessHelper
                                                        .isFreeAccessEnabled()) ...[
                                                      wishItem.discount == 0
                                                          ? Container()
                                                          : GlobalText(
                                                              text: wishItem
                                                                  .discount
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  decoration:
                                                                      TextDecoration
                                                                          .lineThrough,
                                                                  fontSize:
                                                                      10.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: AppColors
                                                                      .titleTextColor),
                                                              softWrap: true,
                                                            ),
                                                      horizontalGap(3.sp),
                                                    ],
                                                    GlobalText(
                                                      text: PriceAccessHelper
                                                          .formatPrice(
                                                              wishItem.price),
                                                      style: TextStyle(
                                                          fontSize: 15.sp,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: AppColors
                                                              .titleTextColor),
                                                      softWrap: true,
                                                    ),
                                                    horizontalGap(5.sp),
                                                  ],
                                                ),
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
            );
          }
        }
      }),
    );
  }
}
