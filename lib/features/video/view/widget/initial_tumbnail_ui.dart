import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:skill_grow/core/colors/app_colors.dart';
import 'package:skill_grow/features/course/controller/toggle_wish_controller.dart';

import '../../../../core/Global/api_endpoint.dart';
import '../../../../core/icons/app_icon.dart';

class InitialTumbnailUI extends StatelessWidget {
  final String thumbnailImage;
  final VoidCallback wishOntap;
  final VoidCallback playOntap;
  final bool isShowWishIcon;
  const InitialTumbnailUI({
    super.key,
    required this.isShowWishIcon,
    required this.thumbnailImage,
    required this.wishOntap,
    required this.playOntap,
  });

  @override
  Widget build(BuildContext context) {
    ToggleWishController toggleWishController = Get.put(ToggleWishController());
    return Stack(
      children: [
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.sp),
            child: Image.network(
              ApiEndpoint.BASE_URL + thumbnailImage,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.sp),
              color: const Color.fromARGB(90, 0, 0, 0),
            ),
          ),
        ),
        if (isShowWishIcon)
          Obx(() {
            return Positioned(
              // alignment: Alignment.topRight,
              right: 10.sp,
              top: 10.sp,
              child: Bounceable(
                onTap: wishOntap,
                child: Container(
                  width: 30.sp,
                  height: 30.sp,
                  padding: EdgeInsets.all(5.sp),
                  decoration: BoxDecoration(
                      color: toggleWishController.isWishActive.value
                          ? Colors.white
                          : const Color.fromARGB(120, 255, 255, 255),
                      borderRadius: BorderRadius.circular(50.sp)),
                  child: SvgPicture.asset(
                    AppIcon.addwishIcon,
                    color: toggleWishController.isWishActive.value
                        ? AppColors.primaryColor
                        : Colors.black87,
                  ),
                ),
              ),
            );
          }),
        Align(
          alignment: Alignment.center,
          child: Bounceable(
            onTap: playOntap,
            child: Container(
              width: 50.sp,
              height: 50.sp,
              padding: EdgeInsets.all(5.sp),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(120, 0, 0, 0),
                  borderRadius: BorderRadius.circular(50.sp)),
              child: SvgPicture.asset(
                AppIcon.playIcon,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
