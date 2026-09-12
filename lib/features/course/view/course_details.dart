// ignore_for_file: unused_local_variable

import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skill_grow/core/colors/app_colors.dart';
import 'package:skill_grow/core/constant/constant.dart';
import 'package:skill_grow/core/widgets/appbar.dart';
import 'package:skill_grow/core/widgets/custom_rating_bar.dart';
import 'package:skill_grow/core/widgets/texts.dart';
import 'package:skill_grow/features/cart/controller/add_to_cart_controller.dart';
import 'package:skill_grow/features/course/controller/course_details_controller.dart';
import 'package:skill_grow/features/course/controller/toggle_wish_controller.dart';
import 'package:skill_grow/features/course/widget/course_info.dart';
import 'package:skill_grow/features/course/widget/loading_ui.dart';
import 'package:skill_grow/features/course/widget/toggle_widget.dart';
import 'package:skill_grow/features/video/controller/video_play_controller.dart';
import '../../mulit_langual_data/controller/multi_langual_data_controller.dart';
import '../../profile/controller/profile_data_cotroller.dart';
import '../../video/view/widget/initial_tumbnail_ui.dart';
import '../../video_player/view/view_player_view.dart';

class CourseDetailsView extends StatelessWidget {
  final String slug;
  const CourseDetailsView({super.key, required this.slug});

  @override
  Widget build(BuildContext context) {
    MultiLangualDataController multiLangualDataController =
        Get.put(MultiLangualDataController());
    AddToCartController addToCartController = Get.put(AddToCartController());
    ProfileDataCotroller profileDataCotroller =
        Get.isRegistered<ProfileDataCotroller>()
            ? Get.find<ProfileDataCotroller>()
            : Get.put(ProfileDataCotroller());

    ToggleWishController toggleWishController = Get.put(ToggleWishController());
    FreeVideoPlayController freevideoPlayController =
        Get.put(FreeVideoPlayController());
    RxBool isShowVideo = false.obs;

    return Scaffold(
      body: ColorfulSafeArea(
        bottom: false,
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Obx(() {
            if (profileDataCotroller.isLoading.value ||
                profileDataCotroller.userDataResponse.value == null) {
              return const Center(child: CircularProgressIndicator());
            }

            final userId =
                profileDataCotroller.userDataResponse.value!.data.id.toString();
            final courseDetalisController =
                Get.isRegistered<CourseDetalisController>(tag: slug)
                    ? Get.find<CourseDetalisController>(tag: slug)
                    : Get.put(
                        CourseDetalisController(slug, userId),
                        tag: slug,
                      );

            if (courseDetalisController.isLoading.value) {
              return CourserDetailsLoading();
            } else if (courseDetalisController.course.value == null) {
              return Center(
                child: GlobalText(
                  text: "جاري تحميل تفاصيل الدورة...",
                  softWrap: true,
                ),
              );
            } else {
              if (courseDetalisController.course.value!.isWishlist == true) {
                toggleWishController.isWishActive.value = true;
              }
              return SingleChildScrollView(
                child: Column(
                  textDirection: multiLangualDataController.isLTR.value
                      ? TextDirection.ltr
                      : TextDirection.rtl,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyCustomAppBar(
                      horizontalPadding: 0,
                      verticalPadding: 0,
                      isShowbackButton: true,
                    ),
                    verticalGap(6.h),
                    Container(
                      width: double.infinity,
                      height: 210.h,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Stack(
                        children: [
                          Obx(() {
                            if (freevideoPlayController.isLoading.value) {
                              return InitialTumbnailUI(
                                  isShowWishIcon: true,
                                  thumbnailImage: courseDetalisController
                                      .course.value!.thumbnail,
                                  wishOntap: () {},
                                  playOntap: () {
                                    freevideoPlayController.fetchVideoFile(
                                        id: courseDetalisController
                                            .course
                                            .value!
                                            .curriculums[0]
                                            .chapters[0]
                                            .lesson!
                                            .id
                                            .toString());
                                  });
                            } else {
                              if (freevideoPlayController.videoFile.value !=
                                  null) {
                                return VideoScreen(
                                    videoSource: freevideoPlayController
                                        .videoFile.value!.data.storage,
                                    videoUrl: freevideoPlayController
                                        .videoFile.value!.data.filePath);
                              } else {
                                return InitialTumbnailUI(
                                    isShowWishIcon: true,
                                    thumbnailImage: courseDetalisController
                                        .course.value!.thumbnail,
                                    wishOntap: () {
                                      toggleWishController.sendStatus(
                                          slug: slug);
                                    },
                                    playOntap: () {
                                      for (int i = 0;
                                          i <
                                              courseDetalisController.course
                                                  .value!.curriculums.length;
                                          i++) {
                                        for (int j = 0;
                                            j <
                                                courseDetalisController
                                                    .course
                                                    .value!
                                                    .curriculums[i]
                                                    .chapters
                                                    .length;
                                            j++) {
                                          if (courseDetalisController
                                                  .course
                                                  .value!
                                                  .curriculums[i]
                                                  .chapters[j]
                                                  .type ==
                                              "lesson") {
                                            freevideoPlayController
                                                .initialVideoDetails.value = {
                                              "id": courseDetalisController
                                                  .course
                                                  .value!
                                                  .curriculums[i]
                                                  .chapters[j]
                                                  .lesson!
                                                  .id
                                                  .toString(),
                                              "slug":
                                                  courseDetalisController.slug,
                                              "type": "lesson"
                                            };
                                            freevideoPlayController
                                                .fetchVideoFile(
                                              id: courseDetalisController
                                                  .course
                                                  .value!
                                                  .curriculums[i]
                                                  .chapters[j]
                                                  .lesson!
                                                  .id
                                                  .toString(),
                                            );
                                            break;
                                          } else {
                                            print("not lesson");
                                          }
                                        }
                                        if (freevideoPlayController
                                                .initialVideoDetails
                                                .value["type"] ==
                                            "lesson") {
                                          break;
                                        }
                                      }
                                    });
                              }
                            }
                          }),
                          Positioned(
                            top: 8.sp,
                            right: multiLangualDataController.isLTR.value
                                ? 8.sp
                                : null,
                            left: multiLangualDataController.isLTR.value
                                ? null
                                : 8.sp,
                            child: Obx(() {
                              if (freevideoPlayController.videoFile.value ==
                                  null) {
                                return const SizedBox.shrink();
                              }
                              final video =
                                  freevideoPlayController.videoFile.value!;
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.4),
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.screen_rotation,
                                    color: Colors.white,
                                    size: 20.sp,
                                  ),
                                  onPressed: () {
                                    Get.to(() => FullScreenVideoScreen(
                                          videoSource: video.data.storage,
                                          videoUrl: video.data.filePath,
                                        ));
                                  },
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                    verticalGap(14.h),
                    GlobalText(
                      text: courseDetalisController.course.value?.title ??
                          "No Title",
                      softWrap: true,
                      style: TextStyle(
                          fontSize: 20.sp,
                          height: 1.25,
                          color: AppColors.titleTextColor,
                          fontWeight: FontWeight.w700),
                    ),
                    verticalGap(6.h),
                    RichText(
                      text: TextSpan(
                        text: "بواسطة ",
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontFamily: "BalooBhaijaan2",
                          fontWeight: FontWeight.w500,
                          color: AppColors.smallTextColor,
                        ),
                        children: [
                          TextSpan(
                            text: translatedText(courseDetalisController
                                    .course.value?.instructor.name ??
                                "مُدرّس غير معروف"),
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                              fontFamily: "BalooBhaijaan2",
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    verticalGap(9.h),
                    Row(
                      textDirection: multiLangualDataController.isLTR.value
                          ? TextDirection.ltr
                          : TextDirection.rtl,
                      children: [
                        CustomRatingBar(
                          rating: courseDetalisController
                                  .course.value?.averageRating ??
                              0,
                          maxRating: 5,
                          iconSize: 15.sp,
                          filledColor: AppColors.primaryColor,
                          unfilledColor: AppColors.activeIconColor,
                        ),
                        horizontalGap(3.sp),
                        GlobalText(
                          text:
                              "(${courseDetalisController.course.value?.reviewsCount ?? 0})",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.smallTextColor,
                          ),
                          softWrap: true,
                        ),
                        // GlobalText(
                        //   text: " | ",
                        //   style: TextStyle(
                        //     fontSize: 12.sp,
                        //     fontWeight: FontWeight.w400,
                        //     color: AppColors.smallTextColor,
                        //   ),
                        //   softWrap: true,
                        // ),
                        // GlobalText(
                        //   text:
                        //       "${courseDetalisController.course.value?.students ?? 0}",
                        //   style: TextStyle(
                        //     fontSize: 12.sp,
                        //     fontWeight: FontWeight.w400,
                        //     color: AppColors.smallTextColor,
                        //   ),
                        //   softWrap: true,
                        // ),
                        // GlobalText(
                        //   text: " طالب",
                        //   style: TextStyle(
                        //     fontSize: 12.sp,
                        //     fontWeight: FontWeight.w400,
                        //     color: AppColors.smallTextColor,
                        //   ),
                        //   softWrap: true,
                        // ),
                      ],
                    ),
                    verticalGap(14.h),
                    CourseInfo(
                        courseDetalisController: courseDetalisController),
                    verticalGap(12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      textDirection: multiLangualDataController.isLTR.value
                          ? TextDirection.ltr
                          : TextDirection.rtl,
                      children: [
                        Expanded(
                          child: Container(
                            height: 64.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.sp),
                            ),
                            child: Column(
                              textDirection:
                                  multiLangualDataController.isLTR.value
                                      ? TextDirection.ltr
                                      : TextDirection.rtl,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: "السعر",
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.smallTextColor,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: " :",
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Wrap(
                                  textDirection:
                                      multiLangualDataController.isLTR.value
                                          ? TextDirection.ltr
                                          : TextDirection.rtl,
                                  crossAxisAlignment: WrapCrossAlignment.end,
                                  children: [
                                    FittedBox(
                                      child: GlobalText(
                                        text: courseDetalisController
                                                .course.value?.price ??
                                            "N/A",
                                        softWrap: true,
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                    horizontalGap(5.sp),
                                    FittedBox(
                                      child: courseDetalisController
                                                  .course.value?.discount ==
                                              0
                                          ? Container()
                                          : GlobalText(
                                              text: courseDetalisController
                                                      .course.value?.discount ??
                                                  "N/A",
                                              softWrap: true,
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w400,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                              ),
                                            ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        horizontalGap(10.sp),
                        Expanded(
                          child: Obx(() {
                            if (addToCartController.isLoading.value) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              return Bounceable(
                                onTap: () {
                                  addToCartController.addToCart(slug);
                                },
                                child: Container(
                                  height: 46.h,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    border: Border.all(
                                        color: AppColors.primaryColor,
                                        width: 1),
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: Center(
                                    child: GlobalText(
                                      text: "إضافة إلى السلة",
                                      softWrap: true,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                          }),
                        ),
                        // horizontalGap(10.sp),
                      ],
                    ),
                    ToggleWidget(
                      courseDetalisController: courseDetalisController,
                    ),
                  ],
                ),
              );
            }
          }),
        ),
      ),
    );
  }
}
