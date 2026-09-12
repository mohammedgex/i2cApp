import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skill_grow/core/Global/api_endpoint.dart';
import 'package:skill_grow/core/colors/app_colors.dart';
import 'package:skill_grow/core/widgets/custom_rating_bar.dart';
import 'package:skill_grow/core/widgets/texts.dart';

class CourseCarouselCard extends StatelessWidget {
  const CourseCarouselCard({
    super.key,
    required this.course,
    required this.isLTR,
    required this.onTap,
  });

  final dynamic course;
  final bool isLTR;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final direction = isLTR ? TextDirection.ltr : TextDirection.rtl;

    return Bounceable(
      onTap: onTap,
      child: Container(
        width: 208.w,
        margin: EdgeInsets.symmetric(horizontal: 6.w),
        padding: EdgeInsets.all(9.w),
        decoration: BoxDecoration(
          color: AppColors.cardBackgroundColor,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: AppColors.textFieldBorderColor),
        ),
        child: Column(
          crossAxisAlignment:
              isLTR ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: SizedBox(
                height: 104.h,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      ApiEndpoint.BASE_URL + course.thumbnail.toString(),
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppColors.nuralItemBackgroundColor,
                        child: Icon(
                          Icons.school_outlined,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                    PositionedDirectional(
                      top: 8.h,
                      start: 8.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 7.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.cardBackgroundColor,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          'دورة',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Align(
              alignment: isLTR ? Alignment.centerLeft : Alignment.centerRight,
              child: GlobalText(
                text: course.title.toString(),
                softWrap: true,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: isLTR ? TextAlign.left : TextAlign.right,
                style: TextStyle(
                  color: AppColors.titleTextColor,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                ),
              ),
            ),
            SizedBox(height: 5.h),
            Row(
              textDirection: direction,
              children: [
                Icon(Icons.person_outline,
                    size: 14.sp, color: AppColors.smallTextColor),
                SizedBox(width: 4.w),
                Expanded(
                  child: GlobalText(
                    text: course.instructor.name.toString(),
                    softWrap: false,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: isLTR ? TextAlign.left : TextAlign.right,
                    style: TextStyle(
                      color: AppColors.smallTextColor,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(width: 6.w),
                // Icon(Icons.people_outline,
                //     size: 14.sp, color: AppColors.smallTextColor),
                // SizedBox(width: 3.w),
                // Text(
                //   '${course.students}',
                //   style: TextStyle(
                //       color: AppColors.smallTextColor, fontSize: 11.sp),
                // ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 7.h),
              child: Divider(height: 1, color: AppColors.textFieldBorderColor),
            ),
            Row(
              textDirection: direction,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomRatingBar(
                  rating: course.averageRating.toDouble(),
                  maxRating: 5,
                  iconSize: 13.sp,
                  filledColor: AppColors.primaryColor,
                  unfilledColor: AppColors.textFieldBorderColor,
                ),
                GlobalText(
                  text: '${course.price}',
                  softWrap: false,
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
