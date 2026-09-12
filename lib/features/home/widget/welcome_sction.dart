import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skill_grow/core/colors/app_colors.dart';
import 'package:skill_grow/features/learining/view/learing_view.dart';
import 'package:skill_grow/features/profile/controller/profile_data_cotroller.dart';
import '../../mulit_langual_data/controller/multi_langual_data_controller.dart';

class WelcomeSction extends StatelessWidget {
  const WelcomeSction({super.key});

  @override
  Widget build(BuildContext context) {
    final profileController = Get.put(ProfileDataCotroller());
    final languageController = Get.put(MultiLangualDataController());
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Obx(() {
        if (profileController.isLoading.value) {
          return Shimmer.fromColors(
            baseColor: AppColors.nuralItemBackgroundColor,
            highlightColor: AppColors.cardBackgroundColor,
            child: Container(
              height: 98.h,
              decoration: BoxDecoration(
                color: AppColors.nuralItemBackgroundColor,
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
          );
        }
        final isLTR = languageController.isLTR.value;
        return Container(
          height: 98.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: AppColors.primaryColorLight,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: AppColors.textFieldBorderColor),
          ),
          child: Row(
            textDirection: isLTR ? TextDirection.ltr : TextDirection.rtl,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: isLTR
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.start,
                  children: [
                    Text(
                      'مرحباً، ${profileController.userDataResponse.value?.data.name ?? ''}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.titleTextColor,
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'لنبدأ التعلم الآن',
                      textAlign: isLTR ? TextAlign.left : TextAlign.right,
                      style: TextStyle(
                        color: AppColors.smallTextColor,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Bounceable(
                onTap: () => Get.to(() => LearingView(isShowbackButton: true)),
                child: Container(
                  height: 42.h,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    textDirection:
                        isLTR ? TextDirection.ltr : TextDirection.rtl,
                    children: [
                      Text('متابعة التعلم',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700)),
                      SizedBox(width: 5.w),
                      const Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.white, size: 13),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
