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
        drawer: _AppDrawer(categoryController: categoryController),
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
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        textDirection: isLTR ? TextDirection.ltr : TextDirection.rtl,
        children: [
          Row(children: [
            Container(
              width: 4.w,
              height: 18.h,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            SizedBox(width: 8.w),
            Container(
              child: GlobalText(
                text: title,
                style: TextStyle(
                  color: AppColors.titleTextColor,
                  fontSize: 19.sp,
                  fontWeight: FontWeight.w700,
                ),
                softWrap: true,
              ),
            ),
          ]),
          // const Spacer(),
          TextButton(
            onPressed: onViewAllTap,
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              backgroundColor: AppColors.primaryColorDark,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GlobalText(
                  text: "View All",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
                  softWrap: false,
                ),
                SizedBox(width: 4.w),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 10.sp,
                  color: AppColors.primaryColorLight,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ===================== DRAWER =====================

class _AppDrawer extends StatelessWidget {
  final MainCategoryController categoryController;

  const _AppDrawer({required this.categoryController});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 320,
      backgroundColor: AppColors.scaffoldBackgroundColor,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(left: Radius.circular(24.r)),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(child: _buildBody(context)),
              // _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 18.h, 14.w, 22.h),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Material(
                color: Colors.white.withOpacity(0.16),
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => Navigator.of(context).pop(),
                  child: Padding(
                    padding: EdgeInsets.all(8.w),
                    child: Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                      size: 18.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            'تصنيفات الدورات',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'اختر المجال الذي تريد تعلمه',
            style: TextStyle(
              color: Colors.white.withOpacity(0.75),
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Obx(() {
      if (categoryController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (categoryController.categories.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 56.w,
                  width: 56.w,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColorLight,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Icon(
                    Icons.inbox_rounded,
                    size: 28.sp,
                    color: AppColors.primaryColor,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'لا توجد تصنيفات متاحة الآن',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.smallTextColor,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
        );
      }
      return ListView.separated(
        padding: EdgeInsets.fromLTRB(14.w, 16.h, 14.w, 16.h),
        itemCount: categoryController.categories.length,
        separatorBuilder: (_, __) => SizedBox(height: 8.h),
        itemBuilder: (context, index) {
          final category = categoryController.categories[index];
          return _DrawerCategoryTile(
            title: category.name,
            onTap: () {
              Navigator.of(context).pop();
              Get.to(() => CategoryResultView(main_category: category.slug));
            },
          );
        },
      );
    });
  }

  Widget _buildFooter() {
    return Container(
      margin: EdgeInsets.fromLTRB(14.w, 0, 14.w, 14.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.primaryColorLight,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.textFieldBorderColor),
      ),
      child: Row(
        children: [
          Container(
            height: 38.w,
            width: 38.w,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(11.r),
            ),
            child: Icon(
              Icons.support_agent_rounded,
              color: Colors.white,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'تحتاج مساعدة؟',
                  style: TextStyle(
                    color: AppColors.titleTextColor,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'تواصل معنا في أي وقت',
                  style: TextStyle(
                    color: AppColors.smallTextColor,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_left_rounded,
            color: AppColors.inactiveIconColor,
            size: 20.sp,
          ),
        ],
      ),
    );
  }
}

class _DrawerCategoryTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _DrawerCategoryTile({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cardBackgroundColor,
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(14.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 11.h),
          child: Row(
            children: [
              Container(
                height: 34.w,
                width: 34.w,
                decoration: BoxDecoration(
                  color: AppColors.primaryColorLight,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.play_lesson_outlined,
                  size: 18.sp,
                  color: AppColors.primaryColor,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  title,
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
                size: 20.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===================== BANNER CAROUSEL =====================

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
            final isActive = _currentPage == index;
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeOutCubic,
                );
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.sp, vertical: 4.h),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  width: isActive ? 20.w : 6.w,
                  height: 6.h,
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.primaryColor
                        : AppColors.activeIconColor.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(4.sp),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
