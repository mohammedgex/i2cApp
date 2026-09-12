import 'dart:async';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skill_grow/core/colors/app_colors.dart';
import 'package:skill_grow/core/constant/constant.dart';
import 'package:skill_grow/core/widgets/appbar.dart';
import 'package:skill_grow/core/widgets/texts.dart';
import 'package:skill_grow/features/categories/controller/category_itme_controller.dart';
import 'package:skill_grow/features/categories/views/category_all_item_view.dart';
import 'package:skill_grow/features/categories/views/category_result_view.dart';
import 'package:skill_grow/features/course/view/all_fresh_course_listView.dart';
import 'package:skill_grow/features/course/view/all_popular_course_listView.dart';
import 'package:skill_grow/features/home/widget/category_section.dart';
import 'package:skill_grow/features/home/widget/fresh_crourse_section.dart';
import 'package:skill_grow/features/home/widget/popular_courses_section.dart';
import 'package:skill_grow/features/home/widget/welcome_sction.dart';
import 'package:skill_grow/features/home/widget/student_reviews_section.dart';
import '../../mulit_langual_data/controller/multi_langual_data_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final multiLangualDataController = Get.put(MultiLangualDataController());
    final isLTR = multiLangualDataController.isLTR.value;

    final MainCategoryController categoryController =
        Get.put(MainCategoryController());

    return ColorfulSafeArea(
      bottom: false,
      color: AppColors.scaffoldBackgroundColor,
      child: Scaffold(
        drawer: Drawer(
          width: 320,
          backgroundColor: AppColors.scaffoldBackgroundColor,
          surfaceTintColor: Colors.transparent,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.horizontal(left: Radius.circular(20)),
          ),
          child: SafeArea(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                children: [
                  Container(
                    height: 124.h,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColorLight,
                      border: Border(
                        bottom:
                            BorderSide(color: AppColors.textFieldBorderColor),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 42.w,
                          width: 42.w,
                          decoration: BoxDecoration(
                            color: AppColors.cardBackgroundColor,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(
                            Icons.menu_book_outlined,
                            color: AppColors.primaryColor,
                            size: 22.sp,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'تصنيفات الدورات',
                                style: TextStyle(
                                  color: AppColors.titleTextColor,
                                  fontSize: 19.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 3.h),
                              Text(
                                'اختر المجال الذي تريد تعلمه',
                                style: TextStyle(
                                  color: AppColors.smallTextColor,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(
                            Icons.close_rounded,
                            color: AppColors.smallTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Obx(() {
                      if (categoryController.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (categoryController.categories.isEmpty) {
                        return Center(
                          child: Text(
                            'لا توجد تصنيفات متاحة الآن',
                            style: TextStyle(
                              color: AppColors.smallTextColor,
                              fontSize: 14.sp,
                            ),
                          ),
                        );
                      }
                      return ListView.separated(
                        padding: EdgeInsets.fromLTRB(12.w, 14.h, 12.w, 24.h),
                        itemCount: categoryController.categories.length,
                        separatorBuilder: (_, __) => SizedBox(height: 5.h),
                        itemBuilder: (context, index) {
                          final category = categoryController.categories[index];
                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12.r),
                              onTap: () {
                                Navigator.of(context).pop();
                                Get.to(() => CategoryResultView(
                                      main_category: category.slug,
                                    ));
                              },
                              child: Container(
                                height: 52.h,
                                padding: EdgeInsets.symmetric(horizontal: 12.w),
                                decoration: BoxDecoration(
                                  color: AppColors.cardBackgroundColor,
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: AppColors.textFieldBorderColor,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 30.w,
                                      width: 30.w,
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryColorLight,
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                      ),
                                      child: Icon(
                                        Icons.play_lesson_outlined,
                                        size: 17.sp,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: Text(
                                        category.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: AppColors.titleTextColor,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_left_rounded,
                                      color: AppColors.inactiveIconColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            textDirection: isLTR ? TextDirection.ltr : TextDirection.rtl,
            children: [
              MyCustomAppBar(isShowMenu: true),
              verticalGap(4.sp),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.sp),
                child: BannerCarousel(
                  banners: const [
                    'assets/images/banner1.webp',
                    'assets/images/banner2.webp',
                    'assets/images/banner3.webp',
                  ],
                ),
              ),
              verticalGap(16.sp),
              const WelcomeSction(),
              verticalGap(24.sp),
              const StudentReviewsSection(),
              verticalGap(28.sp),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.sp),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14.r),
                  child: SizedBox(
                    height: 130.h,
                    width: double.infinity,
                    child: Image.asset(
                      'assets/images/cate-banner.webp',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              verticalGap(20.sp),
              _buildSectionHeader(
                title: "Categories",
                onViewAllTap: () => Get.to(() => CategoryAllItemView()),
                isLTR: isLTR,
              ),
              verticalGap(12.sp),
              CategorySection(),
              verticalGap(28.sp),
              _buildSectionHeader(
                title: "Popular Courses",
                onViewAllTap: () =>
                    Get.to(() => const AllPopularCourseListview()),
                isLTR: isLTR,
              ),
              verticalGap(12.sp),
              PopularCoursesSection(),
              verticalGap(20.sp),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.sp),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14.r),
                  child: SizedBox(
                    height: 130.h,
                    width: double.infinity,
                    child: Image.asset(
                      'assets/images/courses-banner.webp',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              verticalGap(20.sp),
              _buildSectionHeader(
                title: "Fresh Courses",
                onViewAllTap: () =>
                    Get.to(() => const AllFreshCourseListview()),
                isLTR: isLTR,
              ),
              verticalGap(12.sp),
              FreshCourseSection(),
              verticalGap(20.sp),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required VoidCallback onViewAllTap,
    required bool isLTR,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.sp),
      child: Row(
        textDirection: isLTR ? TextDirection.ltr : TextDirection.rtl,
        children: [
          GlobalText(
            text: title,
            style: TextStyle(
              color: AppColors.titleTextColor,
              fontSize: 19.sp,
              fontWeight: FontWeight.w700,
            ),
            softWrap: true,
          ),
          const Spacer(),
          TextButton(
            onPressed: onViewAllTap,
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: GlobalText(
              text: "View All",
              style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
              ),
              softWrap: false,
            ),
          ),
        ],
      ),
    );
  }
}

class BannerCarousel extends StatefulWidget {
  final List<String> banners;

  const BannerCarousel({super.key, required this.banners});

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  late final PageController _pageController;
  late final Timer _autoPlayTimer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1);
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!mounted || widget.banners.isEmpty) return;
      final nextPage = (_currentPage + 1) % widget.banners.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _autoPlayTimer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 180.h,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.banners.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(14.sp),
                child: Image.asset(
                  widget.banners[index],
                  width: double.infinity,
                  height: 210.h,
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        ),
        verticalGap(7.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.banners.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: EdgeInsets.symmetric(horizontal: 3.sp),
              width: _currentPage == index ? 18.w : 6.w,
              height: 6.h,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? AppColors.primaryColor
                    : AppColors.activeIconColor.withOpacity(0.4),
                borderRadius: BorderRadius.circular(4.sp),
              ),
            );
          }),
        ),
      ],
    );
  }
}
