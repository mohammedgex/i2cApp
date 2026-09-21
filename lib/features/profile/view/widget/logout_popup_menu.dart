import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skill_grow/core/colors/app_colors.dart';
import 'package:skill_grow/core/widgets/texts.dart';
import 'package:skill_grow/features/mulit_langual_data/controller/multi_langual_data_controller.dart';
import 'package:skill_grow/features/profile/controller/delete_account_controller.dart';
import 'package:skill_grow/features/profile/controller/log_out_controller.dart';

void showLogoutDialog(BuildContext context, bool isAllDeviceLogout) {
  final logOutController = Get.put(LogOutController());
  final multiLangualDataController = Get.put(MultiLangualDataController());

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => Directionality(
      textDirection: multiLangualDataController.isLTR.value
          ? TextDirection.ltr
          : TextDirection.rtl,
      child: _AppConfirmDialog(
        icon: Icons.logout_rounded,
        accentColor: AppColors.primaryColor,
        title: "تأكيد تسجيل الخروج",
        message: "هل أنت متأكد أنك تريد تسجيل الخروج؟",
        cancelText: "إلغاء",
        confirmText: "تسجيل الخروج",
        onConfirm: () async {
          if (isAllDeviceLogout) {
            await logOutController.logoutFromAllDevices();
          } else {
            await logOutController.logOutFromThisDevice();
          }
          if (dialogContext.mounted) Navigator.pop(dialogContext);
        },
      ),
    ),
  );
}

void showDeleteAccountDialog(BuildContext context) {
  final deleteAccountController = Get.put(DeleteAccountController());
  final multiLangualDataController = Get.put(MultiLangualDataController());

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => Directionality(
      textDirection: multiLangualDataController.isLTR.value
          ? TextDirection.ltr
          : TextDirection.rtl,
      child: _AppConfirmDialog(
        icon: Icons.delete_outline_rounded,
        accentColor: AppColors.mainRedColor,
        title: "حذف الحساب",
        message:
            "هل أنت متأكد أنك تريد حذف حسابك؟ هذا الإجراء لا يمكن التراجع عنه.",
        cancelText: "إلغاء",
        confirmText: "حذف",
        onConfirm: () async {
          final deleted = await deleteAccountController.deleteAccount();
          if (deleted && dialogContext.mounted) {
            Navigator.pop(dialogContext);
          }
        },
      ),
    ),
  );
}
// ===================== SHARED DIALOG =====================

class _AppConfirmDialog extends StatelessWidget {
  final IconData icon;
  final Color accentColor;
  final String title;
  final String message;
  final String cancelText;
  final String confirmText;
  final Future<void> Function() onConfirm;

  const _AppConfirmDialog({
    required this.icon,
    required this.accentColor,
    required this.title,
    required this.message,
    required this.cancelText,
    required this.confirmText,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        padding: EdgeInsets.fromLTRB(22.w, 26.h, 22.w, 18.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 16.h),
            GlobalText(
              text: title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.titleTextColor,
                letterSpacing: 0.2,
              ),
            ),
            SizedBox(height: 8.h),
            GlobalText(
              text: message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.5.sp,
                color: AppColors.smallTextColor,
                height: 1.6,
              ),
            ),
            SizedBox(height: 22.h),
            Row(
              children: [
                Expanded(
                  child: _DialogButton(
                    text: cancelText,
                    onTap: () => Navigator.pop(context),
                    background: AppColors.scaffoldBackgroundColor,
                    foreground: AppColors.titleTextColor,
                    border: AppColors.textFieldBorderColor,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: _DialogButton(
                    text: confirmText,
                    onTap: () async => await onConfirm(),
                    background: accentColor,
                    foreground: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DialogButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color background;
  final Color foreground;
  final Color? border;

  const _DialogButton({
    required this.text,
    required this.onTap,
    required this.background,
    required this.foreground,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(14.r),
        onTap: onTap,
        child: Container(
          height: 46.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            border: border != null ? Border.all(color: border!) : null,
          ),
          child: GlobalText(
            text: text,
            softWrap: false,
            style: TextStyle(
              color: foreground,
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
