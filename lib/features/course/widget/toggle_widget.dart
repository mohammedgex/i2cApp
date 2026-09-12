import 'package:accordion/accordion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skill_grow/core/Global/api_endpoint.dart';
import 'package:skill_grow/core/icons/app_icon.dart';
import 'package:skill_grow/core/widgets/custom_rating_bar.dart';
import 'package:skill_grow/features/course/controller/course_details_controller.dart';
import 'package:skill_grow/features/course/controller/toggle_controller.dart';
import 'package:skill_grow/features/video/controller/video_play_controller.dart';
import '../../../core/colors/app_colors.dart';
import '../../../core/constant/constant.dart';
import '../../../core/widgets/texts.dart';
import '../../mulit_langual_data/controller/multi_langual_data_controller.dart';
import '../controller/course_review_controller.dart';

class ToggleWidget extends StatelessWidget {
  final CourseDetalisController courseDetalisController;
  const ToggleWidget({super.key, required this.courseDetalisController});

  @override
  Widget build(BuildContext context) {
    final FreeVideoPlayController freevideoPlayController =
        Get.put(FreeVideoPlayController());
    MultiLangualDataController multiLangualDataController =
        Get.put(MultiLangualDataController());
    ToggleController toggleController = ToggleController();
    CourseReviewController courseReviewController = Get.put(
        CourseReviewController(courseDetalisController.course.value!.slug));
    return Column(
      textDirection: multiLangualDataController.isLTR.value
          ? TextDirection.ltr
          : TextDirection.rtl,
      children: [
        Container(
          width: double.infinity,
          height: 48.h,
          decoration: BoxDecoration(
            color: AppColors.nuralItemBackgroundColor,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Obx(() {
            return Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                textDirection: multiLangualDataController.isLTR.value
                    ? TextDirection.ltr
                    : TextDirection.rtl,
                children: [
                  Expanded(
                    child: Bounceable(
                      onTap: () {
                        toggleController.selectedIndex(0);
                      },
                      child: Container(
                        height: double.infinity,
                        decoration: BoxDecoration(
                            color: toggleController.selectedIndex.value == 0
                                ? Colors.white
                                : AppColors.nuralItemBackgroundColor,
                            borderRadius: BorderRadius.circular(7.sp)),
                        child: Center(
                          child: GlobalText(
                            text: "Overview",
                            softWrap: false,
                            style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: toggleController.selectedIndex.value == 0
                                    ? AppColors.titleTextColor
                                    : AppColors.inactiveIconColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                  horizontalGap(4.w),
                  Expanded(
                    child: Bounceable(
                      onTap: () {
                        toggleController.selectedIndex(1);
                      },
                      child: Container(
                        height: double.infinity,
                        decoration: BoxDecoration(
                            color: toggleController.selectedIndex.value == 1
                                ? Colors.white
                                : AppColors.nuralItemBackgroundColor,
                            borderRadius: BorderRadius.circular(7.sp)),
                        child: Center(
                          child: GlobalText(
                            text: "Curriculum",
                            softWrap: false,
                            style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: toggleController.selectedIndex.value == 1
                                    ? AppColors.titleTextColor
                                    : AppColors.inactiveIconColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                  horizontalGap(4.w),
                  Expanded(
                    child: Bounceable(
                      onTap: () {
                        toggleController.selectedIndex(2);
                      },
                      child: Container(
                        height: double.infinity,
                        decoration: BoxDecoration(
                            color: toggleController.selectedIndex.value == 2
                                ? Colors.white
                                : AppColors.nuralItemBackgroundColor,
                            borderRadius: BorderRadius.circular(7.sp)),
                        child: Center(
                          child: GlobalText(
                            text: "Reviews",
                            softWrap: false,
                            style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: toggleController.selectedIndex.value == 2
                                    ? AppColors.titleTextColor
                                    : AppColors.inactiveIconColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
        verticalGap(10.sp),
        Obx(() {
          if (toggleController.selectedIndex.value == 0) {
            return Container(
              width: double.infinity,
              // height: 100.sp,
              decoration: BoxDecoration(
                color: AppColors.cardBackgroundColor,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: AppColors.textFieldBorderColor),
              ),
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 10.sp, vertical: 15.sp),
                child: Column(
                  textDirection: multiLangualDataController.isLTR.value
                      ? TextDirection.ltr
                      : TextDirection.rtl,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GlobalText(
                      text: "Description",
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    verticalGap(10.sp),
                    HtmlGlobalText(
                      text: courseDetalisController.course.value!.description,
                      softWrap: true,
                    ),
                  ],
                ),
              ),
            );
          } else if (toggleController.selectedIndex.value == 1) {
            return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.cardBackgroundColor,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: AppColors.textFieldBorderColor),
              ),
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 7.sp, vertical: 15.sp),
                child: Column(
                  textDirection: multiLangualDataController.isLTR.value
                      ? TextDirection.ltr
                      : TextDirection.rtl,
                  children: List.generate(
                      courseDetalisController.course.value!.curriculums.length,
                      (index) {
                    var curriculums = courseDetalisController
                        .course.value!.curriculums[index];
                    return Directionality(
                      textDirection: multiLangualDataController.isLTR.value
                          ? TextDirection.ltr
                          : TextDirection.rtl,
                      child: Accordion(
                        disableScrolling: true,
                        contentVerticalPadding: 0,
                        paddingListTop: 0,
                        paddingListBottom: 0,
                        rightIcon: SvgPicture.asset(
                          AppIcon.arrowDownIcon,
                          color: Colors.black,
                        ),
                        children: [
                          AccordionSection(
                            headerPadding: EdgeInsets.all(10.sp),
                            headerBackgroundColor:
                                AppColors.nuralItemBackgroundColor,
                            contentBackgroundColor:
                                AppColors.nuralItemBackgroundColor,
                            contentBorderColor: Colors.transparent,
                            header: GlobalText(
                              text: curriculums.title,
                              softWrap: true,
                              style: TextStyle(
                                  fontSize: 13.sp,
                                  color: AppColors.titleTextColor),
                            ),
                            content: Column(
                              textDirection:
                                  multiLangualDataController.isLTR.value
                                      ? TextDirection.ltr
                                      : TextDirection.rtl,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: List.generate(
                                  curriculums.chapters.length, (index) {
                                var chapter = curriculums.chapters[index];
                                if (chapter.type == "lesson") {
                                  if (chapter.lesson!.isFree == true) {
                                    return Bounceable(
                                      onTap: () {
                                        freevideoPlayController
                                            .initialVideoDetails.value = {
                                          "id": chapter.lesson!.id.toString(),
                                          "slug": courseDetalisController.slug,
                                          "type": "lesson"
                                        };
                                        freevideoPlayController.fetchVideoFile(
                                          id: chapter.lesson!.id.toString(),
                                        );
                                      },
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                            vertical: 5.sp),
                                        child: ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          minVerticalPadding: 0,
                                          title: GlobalText(
                                            text: chapter.lesson!.title
                                                .toString(),
                                            softWrap: true,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 12.sp),
                                          ),
                                          subtitle: GlobalText(
                                            text: chapter.lesson!.duration
                                                .toString(),
                                            softWrap: true,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 10.sp),
                                          ),
                                          trailing: SvgPicture.asset(
                                            AppIcon.playIcon,
                                            color: AppColors.activeIconColor,
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 5.sp),
                                      child: ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        minVerticalPadding: 0,
                                        title: GlobalText(
                                          text:
                                              chapter.lesson!.title.toString(),
                                          softWrap: true,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: 12.sp),
                                        ),
                                        subtitle: GlobalText(
                                          text: chapter.lesson!.duration
                                              .toString(),
                                          softWrap: true,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: 10.sp),
                                        ),
                                        trailing: SizedBox(
                                          height: 17.sp,
                                          width: 17.sp,
                                          child: SvgPicture.asset(
                                            AppIcon.lockIcon,
                                            color: AppColors.activeIconColor,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                } else if (chapter.type == "quiz") {
                                  return Container(
                                    margin:
                                        EdgeInsets.symmetric(vertical: 5.sp),
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      minVerticalPadding: 0,
                                      title: GlobalText(
                                        text: chapter.quiz!.title,
                                        softWrap: true,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 12.sp),
                                      ),
                                      subtitle: GlobalText(
                                        text: '',
                                        softWrap: true,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 10.sp),
                                      ),
                                      trailing: SizedBox(
                                        height: 17.sp,
                                        width: 17.sp,
                                        child: SvgPicture.asset(
                                          AppIcon.lockIcon,
                                          color: AppColors.activeIconColor,
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return Container(
                                    margin:
                                        EdgeInsets.symmetric(vertical: 5.sp),
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      minVerticalPadding: 0,
                                      title: GlobalText(
                                        text: chapter.lesson!.title,
                                        softWrap: true,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 12.sp),
                                      ),
                                      subtitle: GlobalText(
                                        text: '',
                                        softWrap: true,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 10.sp),
                                      ),
                                      trailing: SizedBox(
                                        height: 17.sp,
                                        width: 17.sp,
                                        child: SvgPicture.asset(
                                          AppIcon.lockIcon,
                                          color: AppColors.activeIconColor,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              }),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            );
          } else {
            return Container(
              width: double.infinity,
              // height: 100.sp,
              decoration: BoxDecoration(
                color: AppColors.cardBackgroundColor,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: AppColors.textFieldBorderColor),
              ),
              child: Obx(() {
                if (courseReviewController.isLoading.value) {
                  return Center(
                    child: Shimmer.fromColors(
                        baseColor: AppColors.nuralItemBackgroundColor,
                        highlightColor: AppColors.shimmerBackgroundColor,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            textDirection:
                                multiLangualDataController.isLTR.value
                                    ? TextDirection.ltr
                                    : TextDirection.rtl,
                            children: [
                              Row(
                                textDirection:
                                    multiLangualDataController.isLTR.value
                                        ? TextDirection.ltr
                                        : TextDirection.rtl,
                                children: [
                                  Container(
                                    height: 50.sp,
                                    width: 50.sp,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:
                                            AppColors.nuralItemBackgroundColor),
                                  ),
                                  horizontalGap(10.sp),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    textDirection:
                                        multiLangualDataController.isLTR.value
                                            ? TextDirection.ltr
                                            : TextDirection.rtl,
                                    children: [
                                      Container(
                                        height: 10.sp,
                                        width: 100.sp,
                                        decoration: BoxDecoration(
                                            color: AppColors
                                                .nuralItemBackgroundColor,
                                            borderRadius:
                                                BorderRadius.circular(10.sp)),
                                      ),
                                      verticalGap(10.sp),
                                      CustomRatingBar(
                                        rating: 5.0,
                                        iconSize: 20.sp,
                                      ),
                                      verticalGap(10.sp),
                                      Container(
                                        height: 10.sp,
                                        width: 250.sp,
                                        decoration: BoxDecoration(
                                            color: AppColors
                                                .nuralItemBackgroundColor,
                                            borderRadius:
                                                BorderRadius.circular(10.sp)),
                                      ),
                                      verticalGap(5.sp),
                                      Container(
                                        height: 10.sp,
                                        width: 200.sp,
                                        decoration: BoxDecoration(
                                            color: AppColors
                                                .nuralItemBackgroundColor,
                                            borderRadius:
                                                BorderRadius.circular(10.sp)),
                                      ),
                                      verticalGap(5.sp),
                                      Container(
                                        height: 10.sp,
                                        width: 250.sp,
                                        decoration: BoxDecoration(
                                            color: AppColors
                                                .nuralItemBackgroundColor,
                                            borderRadius:
                                                BorderRadius.circular(10.sp)),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        )),
                  );
                } else {
                  return Column(
                    textDirection: multiLangualDataController.isLTR.value
                        ? TextDirection.ltr
                        : TextDirection.rtl,
                    children: [
                      // Reviews List inside ListView
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount:
                            courseReviewController.course.value!.data.length,
                        itemBuilder: (context, index) {
                          var reviews =
                              courseReviewController.course.value!.data[index];
                          return Container(
                            padding: EdgeInsets.all(10.sp),
                            decoration: BoxDecoration(
                                color: AppColors.nuralItemBackgroundColor),
                            child: Row(
                              textDirection:
                                  multiLangualDataController.isLTR.value
                                      ? TextDirection.ltr
                                      : TextDirection.rtl,
                              children: [
                                CircleAvatar(
                                  radius: 25.r,
                                  backgroundImage: NetworkImage(
                                      ApiEndpoint.BASE_URL +
                                          courseReviewController
                                              .course.value!.data[0].avatar),
                                ),
                                horizontalGap(10.sp),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  textDirection:
                                      multiLangualDataController.isLTR.value
                                          ? TextDirection.ltr
                                          : TextDirection.rtl,
                                  children: [
                                    GlobalText(
                                      text: reviews.name,
                                      softWrap: true,
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.titleTextColor,
                                      ),
                                    ),
                                    CustomRatingBar(
                                      rating: reviews.rating.toDouble(),
                                      filledColor: AppColors.primaryColor,
                                      unfilledColor: AppColors.activeIconColor,
                                      iconSize: 18.sp,
                                    ),
                                    GlobalText(
                                      text: reviews.review,
                                      softWrap: true,
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w300,
                                        color: AppColors.titleTextColor,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      ),

                      // Pagination Controls at the end of the review list
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          textDirection: multiLangualDataController.isLTR.value
                              ? TextDirection.ltr
                              : TextDirection.rtl,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: courseReviewController.course.value!
                                          .pagination.currentPage >
                                      1
                                  ? () {
                                      // Navigate to the previous page
                                      final prevPage = courseReviewController
                                              .course
                                              .value!
                                              .pagination
                                              .currentPage -
                                          1;
                                      courseReviewController
                                          .fetchCourseReview(prevPage);
                                    }
                                  : null,
                              child: GlobalText(
                                  text: 'Previous',
                                  softWrap: false,
                                  style: TextStyle(
                                    fontFamily: "BalooBhaijaan2",
                                  )),
                            ),
                            Text(
                              'الصفحة ${courseReviewController.course.value!.pagination.currentPage} الي ${courseReviewController.course.value!.pagination.lastPage}',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: courseReviewController.course.value!
                                          .pagination.currentPage <
                                      courseReviewController
                                          .course.value!.pagination.lastPage
                                  ? () {
                                      // Navigate to the next page
                                      final nextPage = courseReviewController
                                              .course
                                              .value!
                                              .pagination
                                              .currentPage +
                                          1;
                                      courseReviewController
                                          .fetchCourseReview(nextPage);
                                    }
                                  : null,
                              child: GlobalText(
                                  text: 'Next',
                                  softWrap: false,
                                  style: TextStyle(
                                    fontFamily: "BalooBhaijaan2",
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
              }),
            );
          }
        })
      ],
    );
  }
}
