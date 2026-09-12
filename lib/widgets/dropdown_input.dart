import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:skill_grow/core/colors/app_colors.dart';
import 'package:skill_grow/core/widgets/texts.dart';
import 'package:skill_grow/features/mulit_langual_data/controller/multi_langual_data_controller.dart';
import 'package:skill_grow/widgets/controller/dropdwon_input_cntroller.dart';

import '../core/icons/app_icon.dart';

class CustomDropDownField extends StatelessWidget {
  final String title;
  final List<String> items;
  final Function(String?) onItemSelected;
  final DropdownController controller; // Make it flexible for each instance
  final MultiLangualDataController multiLangualDataController =
      Get.put(MultiLangualDataController());

  final RxBool isDropdownOpen = false.obs;
  final TextEditingController searchController = TextEditingController();
  final RxList<String> filteredItems = <String>[].obs;

  CustomDropDownField({
    super.key,
    required this.title,
    required this.items,
    required this.onItemSelected,
    required this.controller, // Pass controller as a parameter
  }) {
    filteredItems.assignAll(items);
  }

  void filterItems(String query) {
    if (query.isEmpty) {
      filteredItems.assignAll(items);
    } else {
      filteredItems.assignAll(items
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 46.h,
      child: DropdownButtonHideUnderline(
        child: Obx(() {
          const textDirection = TextDirection.rtl;

          return Directionality(
            textDirection: textDirection, // Ensure direction is applied
            child: DropdownButton2<String>(
              isExpanded: true,
              isDense: true,
              alignment: AlignmentDirectional.centerEnd,
              hint: GlobalText(
                text: translatedText(title),
                style: TextStyle(fontSize: 14.sp),
                softWrap: false,
              ),
              items: filteredItems
                  .map((item) => DropdownMenuItem(
                        value: item,
                        child: Directionality(
                          textDirection: textDirection,
                          child: Text(
                            item,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ))
                  .toList(),
              value: controller.selectedValue.value.isEmpty
                  ? null
                  : controller.selectedValue.value,
              onChanged: (value) {
                controller.updateValue(value);
                onItemSelected(value);
              },
              buttonStyleData: ButtonStyleData(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                height: 46.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: AppColors.textFieldBorderColor),
                  color: AppColors.cardBackgroundColor,
                ),
              ),
              iconStyleData: IconStyleData(
                icon: SvgPicture.asset(
                  AppIcon.arrowDownIcon,
                  width: 14.sp,
                  height: 14.sp,
                ),
                iconSize: 28.sp,
                iconEnabledColor: Colors.grey,
                iconDisabledColor: Colors.grey,
              ),
              dropdownStyleData: DropdownStyleData(
                maxHeight: 240.h,
                direction: multiLangualDataController.isLTR.value
                    ? DropdownDirection.left
                    : DropdownDirection.right,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: AppColors.cardBackgroundColor,
                  border: Border.all(color: AppColors.textFieldBorderColor),
                ),
              ),
              dropdownSearchData: DropdownSearchData(
                searchController: searchController,
                searchInnerWidgetHeight: 40.h,
                searchInnerWidget: Directionality(
                  textDirection:
                      textDirection, // Ensure search field follows direction
                  child: Container(
                    padding:
                        EdgeInsets.only(left: 10.sp, top: 10.sp, right: 10.sp),
                    child: TextField(
                      textDirection: textDirection,
                      controller: searchController,
                      onChanged: filterItems,
                      decoration: InputDecoration(
                        hintText: translatedText("Search"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                    ),
                  ),
                ),
                searchMatchFn: (item, searchValue) {
                  return item.value
                      .toString()
                      .toLowerCase()
                      .contains(searchValue.toLowerCase());
                },
              ),
              onMenuStateChange: (isOpen) {
                if (!isOpen) {
                  searchController.clear();
                }
              },
            ),
          );
        }),
      ),
    );
  }
}
