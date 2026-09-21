import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skill_grow/core/Global/api_endpoint.dart';
import 'package:skill_grow/core/colors/app_colors.dart';
import 'package:skill_grow/core/utils/price_access_helper.dart';
import 'package:skill_grow/core/widgets/appbar.dart';
import 'package:skill_grow/features/course/controller/popular_course_controller.dart';
import 'package:skill_grow/features/course/view/course_details.dart';
import 'package:skill_grow/features/mulit_langual_data/controller/multi_langual_data_controller.dart';
import '../../../core/constant/constant.dart';
import '../../../core/widgets/custom_rating_bar.dart';
import '../../../core/widgets/texts.dart';

class AllPopularCourseListview extends StatelessWidget {
  const AllPopularCourseListview({super.key});

  @override
  Widget build(BuildContext context) {
    MultiLangualDataController multiLangualDataController =
        Get.put(MultiLangualDataController());

    PopularCourseController popularCourseController =
        Get.put(PopularCourseController());
    return Scaffold(
      body: ColorfulSafeArea(
        bottom: false,
        color: AppColors.scaffoldBackgroundColor,
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.sp),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
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
                GlobalText(
                  text: 'Popular Courses',
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.titleTextColor),
                  softWrap: true,
                ),
                verticalGap(5.sp),
                Obx(() {
                  if (popularCourseController.isLoading.value) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return Shimmer.fromColors(
                            baseColor: AppColors.nuralItemBackgroundColor,
                            highlightColor: AppColors.shimmerBackgroundColor,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                children: [
                                  Container(
                                    height: 60.sp,
                                    width: 100.sp,
                                    decoration: BoxDecoration(
                                        color:
                                            AppColors.nuralItemBackgroundColor,
                                        borderRadius:
                                            BorderRadius.circular(7.sp)),
                                  ),
                                  horizontalGap(10.sp),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      // spacing: 10.sp,
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          height: 10.sp,
                                          decoration: BoxDecoration(
                                              color: AppColors
                                                  .nuralItemBackgroundColor,
                                              borderRadius:
                                                  BorderRadius.circular(20.sp)),
                                        ),
                                        verticalGap(5.sp),
                                        Container(
                                          width: 100.sp,
                                          height: 10.sp,
                                          decoration: BoxDecoration(
                                              color: AppColors
                                                  .shimmerBackgroundColor,
                                              borderRadius:
                                                  BorderRadius.circular(20.sp)),
                                        ),
                                        verticalGap(5.sp),
                                        Container(
                                          width: 150.sp,
                                          height: 10.sp,
                                          decoration: BoxDecoration(
                                              color: AppColors
                                                  .nuralItemBackgroundColor,
                                              borderRadius:
                                                  BorderRadius.circular(20.sp)),
                                        ),
                                        verticalGap(5.sp),
                                        Row(
                                          children: [
                                            Container(
                                              width: 100.sp,
                                              height: 10.sp,
                                              decoration: BoxDecoration(
                                                  color: AppColors
                                                      .nuralItemBackgroundColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.sp)),
                                            ),
                                            Spacer(),
                                            Container(
                                              width: 50.sp,
                                              height: 10.sp,
                                              decoration: BoxDecoration(
                                                  color: AppColors
                                                      .nuralItemBackgroundColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.sp)),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return Expanded(
                      child: ListView.builder(
                          itemCount: popularCourseController.courses.length,
                          itemBuilder: (context, index) {
                            return Bounceable(
                              onTap: () {
                                Get.to(() => CourseDetailsView(
                                      slug: popularCourseController
                                          .courses[index].slug,
                                    ));
                              },
                              child: Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.only(bottom: 10.sp),
                                  decoration: BoxDecoration(
                                    // border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(12.sp),
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
                                          height: 65.sp,
                                          width: 103.sp,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(7.sp),
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      ApiEndpoint.BASE_URL +
                                                          popularCourseController
                                                              .courses[index]
                                                              .thumbnail),
                                                  fit: BoxFit.cover)),
                                        ),
                                        horizontalGap(10.sp),
                                        Flexible(
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
                                                text: popularCourseController
                                                    .courses[index].title,
                                                style: TextStyle(
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColors
                                                        .titleTextColor),
                                                softWrap: true,
                                              ),
                                              verticalGap(3.sp),
                                              // GlobalText(
                                              //     text:
                                              //         '${popularCourseController.courses[index].instructor.name} | ${popularCourseController.courses[index].students} Students',
                                              //     style: TextStyle(
                                              //         fontSize: 10.sp,
                                              //         fontWeight:
                                              //             FontWeight.w300,
                                              //         color: AppColors
                                              //             .titleTextColor),
                                              //     softWrap: true),
                                              verticalGap(2.sp),
                                              Row(
                                                textDirection:
                                                    multiLangualDataController
                                                            .isLTR.value
                                                        ? TextDirection.ltr
                                                        : TextDirection.rtl,
                                                children: [
                                                  CustomRatingBar(
                                                    rating:
                                                        popularCourseController
                                                            .courses[index]
                                                            .averageRating,
                                                    maxRating: 5,
                                                    iconSize: 15.sp,
                                                    filledColor: AppColors
                                                        .activeIconColor,
                                                    unfilledColor: AppColors
                                                        .activeIconColor,
                                                  ),
                                                  Spacer(),
                                                  Row(
                                                    textDirection:
                                                        multiLangualDataController
                                                                .isLTR.value
                                                            ? TextDirection.ltr
                                                            : TextDirection.rtl,
                                                    children: [
                                                      popularCourseController
                                                                  .courses[
                                                                      index]
                                                                  .discount ==
                                                              0
                                                          ? Container()
                                                          : GlobalText(
                                                              text: popularCourseController
                                                                  .courses[
                                                                      index]
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
                                                      GlobalText(
                                                        text: PriceAccessHelper
                                                            .formatPrice(
                                                          popularCourseController
                                                              .courses[index]
                                                              .price,
                                                        ),
                                                        style: TextStyle(
                                                            fontSize: 15.sp,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: AppColors
                                                                .smallTextColor),
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
                            );
                          }),
                    );
                  }
                }),
              ],
            )),
      ),
    );
  }
}
