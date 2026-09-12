// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skill_grow/core/Global/api_endpoint.dart';
import 'package:skill_grow/core/colors/app_colors.dart';
import 'package:skill_grow/core/constant/constant.dart';
import 'package:skill_grow/core/widgets/texts.dart';
import 'package:skill_grow/features/categories/controller/category_itme_controller.dart';
import 'package:skill_grow/features/categories/views/category_result_view.dart';
import '../../mulit_langual_data/controller/multi_langual_data_controller.dart';

class CategorySection extends StatelessWidget {
  CategorySection({super.key});
  MainCategoryController categoryItmeController =
      Get.put(MainCategoryController());
  @override
  Widget build(BuildContext context) {
    MultiLangualDataController multiLangualDataController =
        Get.put(MultiLangualDataController());
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.sp),
      child: Obx(() {
        if (categoryItmeController.isLoading.value) {
          return Wrap(
            spacing: 20.sp,
            runSpacing: 20.sp,
            children: List.generate(10, (index) {
              return Shimmer.fromColors(
                baseColor: AppColors.nuralItemBackgroundColor,
                highlightColor: AppColors.shimmerBackgroundColor,
                child: Bounceable(
                    onTap: () {},
                    child: Column(
                      textDirection: multiLangualDataController.isLTR.value
                          ? TextDirection.ltr
                          : TextDirection.rtl,
                      children: [
                        Container(
                          height: 44.sp,
                          width: 44.sp,
                          decoration: BoxDecoration(
                            color: AppColors.nuralItemBackgroundColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        verticalGap(3.sp),
                        Container(
                          height: 11.sp,
                          width: 50.sp,
                          decoration: BoxDecoration(
                            color: AppColors.nuralItemBackgroundColor,
                            borderRadius: BorderRadius.circular(5.sp),
                          ),
                        )
                      ],
                    )),
              );
            }),
          );
        } else {
          return GridView.builder(
            shrinkWrap: true, // Allows GridView to take only necessary space
            physics:
                NeverScrollableScrollPhysics(), // Prevents double scrolling
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 10.sp,
              crossAxisSpacing: 10.sp,
              childAspectRatio: 0.86,
            ),
            itemCount: categoryItmeController.categories.length,
            itemBuilder: (context, index) {
              return Bounceable(
                onTap: () {
                  Get.to(() => CategoryResultView(
                      main_category:
                          categoryItmeController.categories[index].slug));
                },
                child: Column(
                  textDirection: multiLangualDataController.isLTR.value
                      ? TextDirection.ltr
                      : TextDirection.rtl,
                  children: [
                    Container(
                      height: 54.sp,
                      width: 54.sp,
                      padding: EdgeInsets.all(11.sp),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.09),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Image.network(
                          ApiEndpoint.BASE_URL +
                              categoryItmeController.categories[index].icon,
                        ),
                      ),
                    ),
                    verticalGap(4.sp),
                    GlobalText(
                      softWrap: false,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: categoryItmeController.categories[index].name,
                      style: TextStyle(
                        color: AppColors.smallTextColor,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
      }),
    );
  }
}
