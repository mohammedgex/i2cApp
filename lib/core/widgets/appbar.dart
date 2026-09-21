import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:skill_grow/core/utils/price_access_helper.dart';
import 'package:skill_grow/features/cart/view/cart_view.dart';
import 'package:skill_grow/features/course/view/wish_list_view.dart';

import '../../features/cart/controller/cart_list_controller.dart';
import '../../features/mulit_langual_data/controller/multi_langual_data_controller.dart';
import '../colors/app_colors.dart';
import '../icons/app_icon.dart';
import '../images/app_image.dart';

class MyCustomAppBar extends StatelessWidget {
  MyCustomAppBar({
    super.key,
    this.horizontalPadding,
    this.verticalPadding,
    this.isShowbackButton = false,
    this.isShowNotification = true,
    this.isShowMenu = false,
  });

  final double? horizontalPadding;
  final double? verticalPadding;
  final bool isShowbackButton;
  final bool? isShowNotification;
  final bool isShowMenu;
  final MultiLangualDataController multiLangualDataController =
      Get.put(MultiLangualDataController());
  final CartListController cartListController = Get.put(CartListController());

  @override
  Widget build(BuildContext context) {
    final textDirection = multiLangualDataController.isLTR.value
        ? TextDirection.ltr
        : TextDirection.rtl;

    return Container(
      height: 72.h + (verticalPadding ?? 0),
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding ?? 16.w),
      color: AppColors.scaffoldBackgroundColor,
      child: Stack(
        children: [
          Positioned.fill(
            left: 140.w,
            right: 70.w,
            child: Center(
              child: Image.asset(
                AppImage.logo,
                width: 140.w,
                height: 44.h,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Align(
            alignment: textDirection == TextDirection.ltr
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isShowMenu)
                  _iconButton(
                    icon: Icons.menu_rounded,
                    onTap: () => Scaffold.of(context).openDrawer(),
                  ),
                if (isShowbackButton)
                  _iconButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: Get.back,
                  ),
              ],
            ),
          ),
          if (isShowNotification == true)
            Align(
              alignment: textDirection == TextDirection.ltr
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _iconButton(
                    iconAsset: AppIcon.addwishIcon,
                    onTap: () => Get.to(() => WishListView()),
                  ),
                  if (!PriceAccessHelper.shouldHideCart()) ...[
                    SizedBox(width: 8.w),
                    _iconButton(
                      iconAsset: AppIcon.cartIcon,
                      onTap: () => Get.to(() => CartView()),
                      badge: Obx(() {
                        if (cartListController.isLoading.value) {
                          return const SizedBox.shrink();
                        }
                        return Text(
                          cartListController.cartData.value.cartCourses.length
                              .toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 8.sp,
                          ),
                        );
                      }),
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _iconButton({
    IconData? icon,
    String? iconAsset,
    required VoidCallback onTap,
    Widget? badge,
  }) {
    return Bounceable(
      onTap: onTap,
      child: Container(
        width: 46.w,
        height: 46.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.cardBackgroundColor,
          borderRadius: BorderRadius.circular(11.r),
          border: Border.all(color: AppColors.textFieldBorderColor),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Center(
              child: iconAsset != null
                  ? SvgPicture.asset(
                      iconAsset,
                      width: 23.sp,
                      height: 23.sp,
                      color: AppColors.primaryColor,
                    )
                  : Icon(icon, size: 27.sp, color: AppColors.primaryColor),
            ),
            if (badge != null)
              PositionedDirectional(
                top: 3.h,
                end: 3.w,
                child: Container(
                  height: 17.sp,
                  width: 17.sp,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.mainRedColor,
                    shape: BoxShape.circle,
                  ),
                  child: badge,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
