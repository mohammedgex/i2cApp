import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skill_grow/core/colors/app_colors.dart';
import 'package:skill_grow/features/course/controller/fresh_course_conroller.dart';
import 'package:skill_grow/features/course/view/course_details.dart';
import 'package:skill_grow/features/mulit_langual_data/controller/multi_langual_data_controller.dart';

import 'course_carousel_card.dart';

class FreshCourseSection extends StatelessWidget {
  FreshCourseSection({super.key});

  final FreshCourseConroller freshCourseController =
      Get.put(FreshCourseConroller());

  @override
  Widget build(BuildContext context) {
    final languageController = Get.put(MultiLangualDataController());

    return Obx(() {
      if (freshCourseController.isLoading.value) {
        return _buildLoadingCards();
      }

      final courses = freshCourseController.courses.take(4).toList();
      return SizedBox(
        height: 222.h,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 9.w),
          itemCount: courses.length,
          separatorBuilder: (_, __) => SizedBox(width: 2.w),
          itemBuilder: (_, index) => CourseCarouselCard(
            course: courses[index],
            isLTR: languageController.isLTR.value,
            onTap: () => Get.to(
              () => CourseDetailsView(slug: courses[index].slug),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildLoadingCards() {
    return SizedBox(
      height: 222.h,
      child: Shimmer.fromColors(
        baseColor: AppColors.nuralItemBackgroundColor,
        highlightColor: AppColors.cardBackgroundColor,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          itemCount: 3,
          separatorBuilder: (_, __) => SizedBox(width: 12.w),
          itemBuilder: (_, __) => Container(
            width: 208.w,
            decoration: BoxDecoration(
              color: AppColors.nuralItemBackgroundColor,
              borderRadius: BorderRadius.circular(14.r),
            ),
          ),
        ),
      ),
    );
  }
}
