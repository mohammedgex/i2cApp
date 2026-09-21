import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skill_grow/core/Global/api_endpoint.dart';
import 'package:skill_grow/core/utils/price_access_helper.dart';
import 'package:skill_grow/core/widgets/appbar.dart';
import 'package:skill_grow/core/widgets/custom_rating_bar.dart';
import 'package:skill_grow/features/course/view/course_details.dart';

import '../../../core/colors/app_colors.dart';
import '../../../core/constant/constant.dart';
import '../../../core/widgets/texts.dart';
import '../../mulit_langual_data/controller/multi_langual_data_controller.dart';
import '../controller/search_data_controller.dart';

class SearchDetalsView extends StatelessWidget {
  final String search;
  final String main_category;
  final String sub_category;
  final String price;
  final String languages_code;
  final String levels;
  final String rating;

  const SearchDetalsView({
    super.key,
    required this.search,
    required this.main_category,
    required this.sub_category,
    required this.price,
    required this.languages_code,
    required this.levels,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    final MultiLangualDataController multiLangualDataController =
        Get.put(MultiLangualDataController());
    final SearchDataController searchDataController =
        Get.put(SearchDataController());

    final ScrollController scrollController = ScrollController();

    // Fetch initial data when the view is loaded
    searchDataController.fetchSearchData(
      search: search,
      main_category: main_category,
      sub_category: sub_category,
      price: price,
      languages_code: languages_code,
      levels: levels,
      rating: rating,
    );

    // Load more data when the user scrolls to the bottom
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          searchDataController.hasMore.value &&
          !searchDataController.isLoading.value) {
        searchDataController.fetchSearchData(
          search: search,
          main_category: main_category,
          sub_category: sub_category,
          price: price,
          languages_code: languages_code,
          levels: levels,
          rating: rating,
          loadMore: true, // Load more data
        );
      }
    });

    return Scaffold(
      body: Obx(() {
        if (searchDataController.isLoading.value &&
            searchDataController.page.value == 1) {
          return const Center(child: CircularProgressIndicator());
        } else if (searchDataController.searchResults.isEmpty) {
          return SafeArea(
            child: Column(
              children: [
                MyCustomAppBar(
                  horizontalPadding: 15.sp,
                  verticalPadding: 0,
                  isShowbackButton: true,
                ),
                const Spacer(),
                GlobalText(
                  text: "No Data Found",
                  softWrap: true,
                ),
                const Spacer(),
              ],
            ),
          );
        } else {
          return ColorfulSafeArea(
            bottom: false,
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.sp),
              child: Column(
                textDirection: multiLangualDataController.isLTR.value
                    ? TextDirection.ltr
                    : TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyCustomAppBar(
                    horizontalPadding: 0,
                    verticalPadding: 0,
                    isShowbackButton: true,
                  ),
                  GlobalText(
                    text: 'Search Results',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.titleTextColor,
                    ),
                    softWrap: false,
                  ),
                  verticalGap(10.sp),
                  Expanded(
                    child: ListView.builder(
                      controller:
                          scrollController, // Attach the ScrollController
                      itemCount: searchDataController.searchResults.length +
                          (searchDataController.hasMore.value &&
                                  searchDataController.searchResults.isNotEmpty
                              ? 1
                              : 0), // Add 1 for loader only if there is more data and the list is not empty
                      itemBuilder: (context, index) {
                        // Show loader or "No more data" message at the bottom
                        if (searchDataController.hasMore.value &&
                            index ==
                                searchDataController.searchResults.length) {
                          return Padding(
                            padding: EdgeInsets.all(10.sp),
                            child: Center(
                              child:
                                  CircularProgressIndicator(), // Show loading indicator
                            ),
                          );
                        }

                        // Display search results
                        final result =
                            searchDataController.searchResults[index];
                        return Bounceable(
                          onTap: () {
                            Get.to(() => CourseDetailsView(slug: result.slug));
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10.sp),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.sp),
                              color: AppColors.nuralItemBackgroundColor,
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
                                    height: 60.sp,
                                    width: 103.sp,
                                    decoration: BoxDecoration(),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5.r),
                                      child: Image.network(
                                        ApiEndpoint.BASE_URL + result.thumbnail,
                                        fit: BoxFit.cover,
                                      ),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        GlobalText(
                                          text: result.title,
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.titleTextColor,
                                          ),
                                          softWrap: true,
                                        ),
                                        verticalGap(3.sp),
                                        GlobalText(
                                          text:
                                              '${result.instructor.name} | ${result.students} Students',
                                          style: TextStyle(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w300,
                                            color: AppColors.titleTextColor,
                                          ),
                                          softWrap: true,
                                        ),
                                        verticalGap(2.sp),
                                        Row(
                                          textDirection:
                                              multiLangualDataController
                                                      .isLTR.value
                                                  ? TextDirection.ltr
                                                  : TextDirection.rtl,
                                          children: [
                                            CustomRatingBar(
                                              rating: result.average_rating,
                                              maxRating: 5,
                                              iconSize: 15.sp,
                                              filledColor:
                                                  AppColors.activeIconColor,
                                              unfilledColor:
                                                  AppColors.activeIconColor,
                                            ),
                                            const Spacer(),
                                            Row(
                                              textDirection:
                                                  multiLangualDataController
                                                          .isLTR.value
                                                      ? TextDirection.ltr
                                                      : TextDirection.rtl,
                                              children: [
                                                if (!PriceAccessHelper
                                                    .isFreeAccessEnabled()) ...[
                                                  result.discount == 0
                                                      ? Container()
                                                      : GlobalText(
                                                          text: result.discount
                                                              .toString(),
                                                          style: TextStyle(
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough,
                                                            fontSize: 10.sp,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: AppColors
                                                                .titleTextColor,
                                                          ),
                                                          softWrap: true,
                                                        ),
                                                  horizontalGap(3.sp),
                                                ],
                                                GlobalText(
                                                  text: PriceAccessHelper
                                                      .formatPrice(
                                                          result.price),
                                                  style: TextStyle(
                                                    fontSize: 15.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColors
                                                        .titleTextColor,
                                                  ),
                                                  softWrap: true,
                                                ),
                                                horizontalGap(5.sp),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      }),
    );
  }
}
