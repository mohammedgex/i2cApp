import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:skill_grow/core/colors/app_colors.dart';
import 'package:skill_grow/core/constant/constant.dart';
import 'package:skill_grow/core/icons/app_icon.dart';
import 'package:skill_grow/core/images/app_image.dart';
import 'package:skill_grow/core/widgets/button.dart';
import 'package:skill_grow/core/widgets/texts.dart';
import 'package:skill_grow/features/mulit_langual_data/controller/multi_langual_data_controller.dart';
import 'package:skill_grow/features/search/controller/search_data_controller.dart';
import 'package:skill_grow/features/search/controller/sub_category_list_controller.dart';
import 'package:skill_grow/features/search/view/search_detals.dart'
    show SearchDetalsView;
import 'package:skill_grow/widgets/dropdown_input.dart';
import 'package:skill_grow/widgets/text_input.dart';
import '../../../widgets/controller/dropdwon_input_cntroller.dart';
import '../../categories/controller/category_itme_controller.dart';
import '../controller/course_language_controller.dart';
import '../controller/course_level_controller.dart';

class SearchView extends StatelessWidget {
  String subCategorySelectValue = "";
  TextEditingController searchController = TextEditingController();
  DropdownController categorySelectedController = DropdownController();
  DropdownController subCategorySelectedController = DropdownController();
  DropdownController languageSelectedController = DropdownController();
  DropdownController levelSelectedController = DropdownController();
  DropdownController priceSelectedController = DropdownController();
  DropdownController ratingSelectedController = DropdownController();
  SearchDataController searchDataController = Get.put(SearchDataController());

  SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final MultiLangualDataController multiLangualDataController =
        Get.put(MultiLangualDataController());
    final CourseLanguageController courseLanguageController =
        Get.put(CourseLanguageController());
    final CourseLevelController courseLevelController =
        Get.put(CourseLevelController());
    final MainCategoryController mainCategoryController =
        Get.put(MainCategoryController());
    final SubCategoryListController subCategoryListController =
        Get.put(SubCategoryListController());

    return Scaffold(
      extendBody: false,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            top: 10.h,
          ),
          child: SingleChildScrollView(
            child: Column(
              textDirection: multiLangualDataController.isLTR.value
                  ? TextDirection.ltr
                  : TextDirection.rtl,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAppBar(multiLangualDataController),
                verticalGap(10.sp),
                _buildSearchSection(multiLangualDataController),
                verticalGap(10.sp),
                _buildCategorySection(
                    multiLangualDataController, mainCategoryController),
                verticalGap(10.sp),
                _buildSubCategorySection(
                    multiLangualDataController, subCategoryListController),
                verticalGap(10.sp),
                _buildPricingSection(multiLangualDataController),
                verticalGap(10.sp),
                _buildLanguageSection(
                    multiLangualDataController, courseLanguageController),
                verticalGap(10.sp),
                _buildLevelSection(
                    multiLangualDataController, courseLevelController),
                verticalGap(10.sp),
                _buildRatingSection(multiLangualDataController),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // App Bar Section
  Widget _buildAppBar(MultiLangualDataController multiLangualDataController) {
    return Row(
      textDirection: multiLangualDataController.isLTR.value
          ? TextDirection.ltr
          : TextDirection.rtl,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Spacer(),
        Image.asset(
          AppImage.logo,
          width: 108.w,
          height: 34.h,
        ),
        const Spacer(),
      ],
    );
  }

  // Search Section
  Widget _buildSearchSection(
      MultiLangualDataController multiLangualDataController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GlobalText(
          softWrap: false,
          text: 'Search',
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.titleTextColor,
          ),
        ),
        verticalGap(5.sp),
        CustomTextField(
          controller: searchController,
          hint: "Search Courses",
          keyName: "Search Courses",
          inputType: TextInputType.text,
        ),
      ],
    );
  }

  // Category Section
  Widget _buildCategorySection(
    MultiLangualDataController multiLangualDataController,
    MainCategoryController mainCategoryController,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GlobalText(
          softWrap: false,
          text: 'Category',
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.titleTextColor,
          ),
        ),
        verticalGap(5.sp),
        Obx(() {
          if (mainCategoryController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return CustomDropDownField(
              title: "All Category",
              items: mainCategoryController.categories
                  .map((category) => category.name)
                  .toList(),
              onItemSelected: (value) {
                final selectedCategory = mainCategoryController.categories
                    .firstWhere((category) => category.name == value);
                SubCategoryListController subCategoryListController =
                    Get.put(SubCategoryListController());
                subCategoryListController
                    .fetchSubCategories(selectedCategory.slug);
              },
              controller: categorySelectedController,
            );
          }
        }),
      ],
    );
  }

  // Sub Category Section
  Widget _buildSubCategorySection(
    MultiLangualDataController multiLangualDataController,
    SubCategoryListController subCategoryListController,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GlobalText(
          softWrap: false,
          text: 'Sub Category',
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.titleTextColor,
          ),
        ),
        verticalGap(5.sp),
        Obx(() {
          if (subCategoryListController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (subCategoryListController.subCategories.isEmpty) {
            return _buildEmptySubCategorySection(multiLangualDataController);
          } else {
            return CustomDropDownField(
              title: "Sub Category",
              items: subCategoryListController.subCategories
                  .map((category) => category.name)
                  .toList(),
              onItemSelected: (value) {
                // Handle subcategory selection
                for (var element in subCategoryListController.subCategories) {
                  if (element.name == value) {
                    subCategorySelectValue = element.slug;
                  }
                }
              },
              controller: subCategorySelectedController,
            );
          }
        }),
      ],
    );
  }

  // Empty Sub Category Section
  Widget _buildEmptySubCategorySection(
      MultiLangualDataController multiLangualDataController) {
    final RxBool isEmpty = false.obs;
    return GestureDetector(
      onTap: () {
        isEmpty.value = true;
      },
      child: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 50.sp,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  color: isEmpty.value ? AppColors.mainRedColor : Colors.grey,
                  width: 1.2.sp,
                ),
                borderRadius: BorderRadius.circular(10.sp),
              ),
              child: Center(
                child: Row(
                  children: [
                    horizontalGap(15.sp),
                    GlobalText(
                      softWrap: false,
                      text: 'Sub Category',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.onboardingSubtitleTextColor,
                      ),
                    ),
                    const Spacer(),
                    SvgPicture.asset(
                      AppIcon.arrowDownIcon,
                      width: 14.sp,
                      height: 14.sp,
                    ),
                    horizontalGap(10.sp),
                  ],
                ),
              ),
            ),
            if (isEmpty.value) verticalGap(3.sp),
            if (isEmpty.value)
              GlobalText(
                softWrap: false,
                text: 'Please Select Category First',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.mainRedColor,
                ),
              ),
          ],
        );
      }),
    );
  }

  // Pricing Section
  Widget _buildPricingSection(
      MultiLangualDataController multiLangualDataController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GlobalText(
          softWrap: false,
          text: 'Pricing',
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.titleTextColor,
          ),
        ),
        verticalGap(5.sp),
        CustomDropDownField(
          title: "All Pricing",
          items: const ["All", "Free", "Paid"],
          onItemSelected: (value) {
            // Handle pricing selection
          },
          controller: priceSelectedController,
        ),
      ],
    );
  }

  // Language Section
  Widget _buildLanguageSection(
    MultiLangualDataController multiLangualDataController,
    CourseLanguageController courseLanguageController,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GlobalText(
          softWrap: false,
          text: 'Language',
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.titleTextColor,
          ),
        ),
        verticalGap(5.sp),
        Obx(() {
          if (courseLanguageController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return CustomDropDownField(
              title: "All Language",
              items: courseLanguageController.languages
                  .map((language) => language.name)
                  .toList(),
              onItemSelected: (value) {
                // Handle language selection
              },
              controller: languageSelectedController,
            );
          }
        }),
      ],
    );
  }

  // Level Section
  Widget _buildLevelSection(
    MultiLangualDataController multiLangualDataController,
    CourseLevelController courseLevelController,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GlobalText(
          text: 'Level',
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.titleTextColor,
          ),
          softWrap: false,
        ),
        verticalGap(5.sp),
        Obx(() {
          if (courseLevelController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return CustomDropDownField(
              title: "All Level",
              items: courseLevelController.levels
                  .map((level) => level.name)
                  .toList(),
              onItemSelected: (value) {
                // Handle level selection
              },
              controller: levelSelectedController,
            );
          }
        }),
      ],
    );
  }

  // Rating Section
  Widget _buildRatingSection(
      MultiLangualDataController multiLangualDataController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GlobalText(
          softWrap: false,
          text: 'Rating',
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.titleTextColor,
          ),
        ),
        verticalGap(5.sp),
        CustomDropDownField(
          title: "All Rating",
          items: const ["1", "2", "3", "4", "5"],
          onItemSelected: (value) {
            // Handle rating selection
          },
          controller: ratingSelectedController,
        ),
        verticalGap(20.sp),
        Row(
          textDirection: multiLangualDataController.isLTR.value
              ? TextDirection.ltr
              : TextDirection.rtl,
          children: [
            Expanded(
              child: Bounceable(
                onTap: () {
                  searchController.clear();
                  categorySelectedController.resetValue();
                  subCategorySelectedController.resetValue();
                  languageSelectedController.resetValue();
                  levelSelectedController.resetValue();
                  priceSelectedController.resetValue();
                  ratingSelectedController.resetValue();
                },
                child: Container(
                  height: 50.sp,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.primaryColor,
                      width: 1.2.sp,
                    ),
                    borderRadius: BorderRadius.circular(10.sp),
                  ),
                  child: Center(
                    child: GlobalText(
                      text: "Clear",
                      softWrap: true,
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ),
            horizontalGap(10.sp),
            GlobalButton(
              height: 50.sp,
              width: 220.sp,
              text: "Search",
              onTap: () {
                // Fetch data and navigate to SearchDetalsView
                searchDataController.fetchSearchData(
                  search: searchController.text.trim(),
                  main_category: categorySelectedController.selectedValue.value,
                  sub_category:
                      subCategorySelectedController.selectedValue.value,
                  price: priceSelectedController.selectedValue.value,
                  languages_code:
                      languageSelectedController.selectedValue.value,
                  levels: levelSelectedController.selectedValue.value,
                  rating: ratingSelectedController.selectedValue.value,
                );

                // Navigate to SearchDetalsView with search parameters
                Get.to(
                  () => SearchDetalsView(
                    search: searchController.text.trim(),
                    main_category:
                        categorySelectedController.selectedValue.value,
                    sub_category:
                        subCategorySelectedController.selectedValue.value,
                    price: priceSelectedController.selectedValue.value,
                    languages_code:
                        languageSelectedController.selectedValue.value,
                    levels: levelSelectedController.selectedValue.value,
                    rating: ratingSelectedController.selectedValue.value,
                  ),
                );
              },
            )
          ],
        ),
        verticalGap(20.sp),
      ],
    );
  }
}
