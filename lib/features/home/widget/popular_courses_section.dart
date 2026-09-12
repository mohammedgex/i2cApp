// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skill_grow/core/colors/app_colors.dart';
import 'package:skill_grow/core/constant/constant.dart';
import 'package:skill_grow/features/course/controller/popular_course_controller.dart';
import '../../course/view/course_details.dart';
import '../../mulit_langual_data/controller/multi_langual_data_controller.dart';
import 'course_carousel_card.dart';

class PopularCoursesSection extends StatelessWidget {
  PopularCoursesSection({super.key});

  final PopularCourseController popularCourseItemController =
      Get.put(PopularCourseController());

  @override
  Widget build(BuildContext context) {
    final MultiLangualDataController multiLangualDataController =
        Get.put(MultiLangualDataController());

    return Padding(
      padding: EdgeInsets.only(left: 0.sp),
      child: Obx(() {
        if (popularCourseItemController.isLoading.value) {
          return _buildShimmerEffect();
        } else {
          return _buildCourseList(multiLangualDataController);
        }
      }),
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: AppColors.nuralItemBackgroundColor,
      highlightColor: AppColors.shimmerBackgroundColor,
      child: SizedBox(
        height: 171.sp,
        child: ListView.builder(
            // shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(right: 10.sp),
                child: Column(
                    textDirection: multiLangualDataController.isLTR.value
                        ? TextDirection.ltr
                        : TextDirection.rtl,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 101.sp,
                        width: 159.sp,
                        decoration: BoxDecoration(
                          color: AppColors.nuralItemBackgroundColor,
                          borderRadius: BorderRadius.circular(10.sp),
                        ),
                      ),
                      verticalGap(5.sp),
                      Container(
                        height: 8.sp,
                        width: 150.sp,
                        decoration: BoxDecoration(
                          color: AppColors.nuralItemBackgroundColor,
                          borderRadius: BorderRadius.circular(10.sp),
                        ),
                      ),
                      verticalGap(5.sp),
                      Container(
                        height: 8.sp,
                        width: 100.sp,
                        decoration: BoxDecoration(
                          color: AppColors.nuralItemBackgroundColor,
                          borderRadius: BorderRadius.circular(10.sp),
                        ),
                      ),
                      verticalGap(7.sp),
                      Container(
                        height: 8.sp,
                        width: 150.sp,
                        decoration: BoxDecoration(
                          color: AppColors.nuralItemBackgroundColor,
                          borderRadius: BorderRadius.circular(10.sp),
                        ),
                      ),
                      Spacer(),
                      Row(
                          textDirection: multiLangualDataController.isLTR.value
                              ? TextDirection.ltr
                              : TextDirection.rtl,
                          children: [
                            Container(
                              height: 20.sp,
                              width: 100.sp,
                              decoration: BoxDecoration(
                                color: AppColors.nuralItemBackgroundColor,
                                borderRadius: BorderRadius.circular(10.sp),
                              ),
                            ),
                            horizontalGap(5.sp),
                            Container(
                              height: 20.sp,
                              width: 50.sp,
                              decoration: BoxDecoration(
                                color: AppColors.nuralItemBackgroundColor,
                                borderRadius: BorderRadius.circular(10.sp),
                              ),
                            ),
                          ])
                    ]),
              );
            }),
      ),
    );
  }

  Widget _buildCourseList(
      MultiLangualDataController multiLangualDataController) {
    return SizedBox(
      height: 222.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 9.w),
        itemCount: popularCourseItemController.courses.length > 4
            ? 4
            : popularCourseItemController.courses.length,
        separatorBuilder: (_, __) => SizedBox(width: 2.w),
        itemBuilder: (_, index) =>
            _buildCourseItem(index, multiLangualDataController),
      ),
    );
  }

  Widget _buildCourseItem(
      int index, MultiLangualDataController multiLangualDataController) {
    final course = popularCourseItemController.courses[index];
    return CourseCarouselCard(
      course: course,
      isLTR: multiLangualDataController.isLTR.value,
      onTap: () => Get.to(() => CourseDetailsView(slug: course.slug)),
    );
  }
}
