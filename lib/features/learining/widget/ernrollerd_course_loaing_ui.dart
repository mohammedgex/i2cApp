import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skill_grow/features/mulit_langual_data/controller/multi_langual_data_controller.dart';

import '../../../core/colors/app_colors.dart';
import '../../../core/constant/constant.dart';
import '../../../core/images/app_image.dart';
import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/texts.dart';

class ErnrollerdCourseLoaingUi extends StatelessWidget {
  const ErnrollerdCourseLoaingUi({super.key});

  @override
  Widget build(BuildContext context) {
    MultiLangualDataController multiLangualDataController =
        Get.put(MultiLangualDataController());
    return Shimmer.fromColors(
      baseColor: AppColors.nuralItemBackgroundColor,
      highlightColor: AppColors.shimmerBackgroundColor,
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
              isShowbackButton: false,
            ),
            GlobalText(
              text: "My Learnings",
              softWrap: true,
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          // border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12.sp),
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
                                decoration: BoxDecoration(),
                                child: Image.asset(
                                  AppImage.image1,
                                  // fit: BoxFit.cover,
                                ),
                              ),
                              horizontalGap(10.sp),
                              SizedBox(
                                width: 235.w,
                                child: Column(
                                  textDirection:
                                      multiLangualDataController.isLTR.value
                                          ? TextDirection.ltr
                                          : TextDirection.rtl,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GlobalText(
                                      text:
                                          'Master Laravel 11 & PHP: From Beginner to Advanced',
                                      style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.titleTextColor),
                                      softWrap: true,
                                    ),
                                    verticalGap(3.sp),
                                    GlobalText(
                                        text: 'Web Solution Us',
                                        style: TextStyle(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w300,
                                            color: AppColors.titleTextColor),
                                        softWrap: true),
                                    verticalGap(2.sp),
                                    Row(
                                      textDirection:
                                          multiLangualDataController.isLTR.value
                                              ? TextDirection.ltr
                                              : TextDirection.rtl,
                                      children: [
                                        SizedBox(
                                          width: 170.w,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5.sp),
                                            child: LinearProgressIndicator(
                                              minHeight: 10.sp,
                                              value: 0.7,
                                              color: AppColors.primaryColor,
                                              backgroundColor:
                                                  Colors.grey.shade200,
                                            ),
                                          ),
                                        ),
                                        horizontalGap(10.sp),
                                        GlobalText(
                                          text: r'70/100',
                                          style: TextStyle(
                                              fontSize: 12.sp,
                                              color: AppColors.titleTextColor),
                                          softWrap: true,
                                        ),
                                        horizontalGap(5.sp)
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ));
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
