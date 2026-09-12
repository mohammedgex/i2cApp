import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:skill_grow/core/colors/app_colors.dart';
import 'package:skill_grow/core/widgets/snackbar.dart';
import 'package:skill_grow/core/widgets/texts.dart';
import 'package:skill_grow/features/navigation_bar/views/bottom_navigation_bar.dart';
import 'package:skill_grow/features/payment/service/manual_payment_service.dart';

class ManualPaymentScreen extends StatefulWidget {
  const ManualPaymentScreen({Key? key}) : super(key: key);

  @override
  State<ManualPaymentScreen> createState() => _ManualPaymentScreenState();
}

class _ManualPaymentScreenState extends State<ManualPaymentScreen> {
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  final ManualPaymentService _manualPaymentService = ManualPaymentService();

  String? _selectedPaymentMethod;
  File? _paymentReceipt;
  bool _isSubmitting = false;

  final List<Map<String, String>> _paymentMethods = [
    {'label': 'فودافون كاش', 'value': 'vodafone_cash'},
    {'label': 'إنستا باي', 'value': 'instapay'},
    {'label': 'ماستركارد العراق', 'value': 'iraqi_master'},
    {'label': 'بينانس', 'value': 'binance'},
    {'label': 'محفظة برق', 'value': 'barq_wallet'},
    {'label': 'موبايلي باي', 'value': 'mobily_pay'},
    {'label': 'مصرف الراجحي', 'value': 'alrajhi_bank'},
  ];

  final Map<String, Map<String, String>> _paymentDetails = {
    'vodafone_cash': {'رقم المحفظة': '01032662002'},
    'instapay': {'رقم إنستا باي': '01033164949'},
    'iraqi_master': {'رقم البطاقة': '7111565797'},
    'binance': {'Binance Pay ID': '836055773'},
    'barq_wallet': {'رقم المحفظة': '00966564547890'},
    'mobily_pay': {'رقم المحفظة': '00966564547890'},
    'alrajhi_bank': {
      'الاسم': 'عبدالحق كمال عبدالحق احمد',
      'رقم الحساب': '262000010006082004126',
      'IBAN': 'SA13 8000 0262 6080 1200 4126',
      'SWIFT': 'RJHISARI',
    },
  };

  @override
  void dispose() {
    _accountController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickReceiptImage() async {
    final XFile? result = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (result != null) {
      setState(() {
        _paymentReceipt = File(result.path);
      });
    }
  }

  bool _validateInputs() {
    if (_selectedPaymentMethod == null) {
      customSnackbar(
        title: 'خطأ',
        message: 'اختر طريقة الدفع أولاً.',
        type: CustomSnackbarType.failed,
      );
      return false;
    }

    if (_accountController.text.trim().isEmpty) {
      customSnackbar(
        title: 'خطأ',
        message: 'أدخل رقم الحساب أو رقم التحويل.',
        type: CustomSnackbarType.failed,
      );
      return false;
    }

    if (_amountController.text.trim().isEmpty) {
      customSnackbar(
        title: 'خطأ',
        message: 'أدخل المبلغ.',
        type: CustomSnackbarType.failed,
      );
      return false;
    }

    final double? amount = double.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) {
      customSnackbar(
        title: 'خطأ',
        message: 'أدخل مبلغًا صالحًا أكبر من صفر.',
        type: CustomSnackbarType.failed,
      );
      return false;
    }

    if (_paymentReceipt == null) {
      customSnackbar(
        title: 'خطأ',
        message: 'اختر صورة الإيصال من المعرض.',
        type: CustomSnackbarType.failed,
      );
      return false;
    }

    return true;
  }

  Future<void> _submitManualPayment() async {
    if (!_validateInputs()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final response = await _manualPaymentService.submitManualPayment(
        paymentMethod: _selectedPaymentMethod!,
        accountNumber: _accountController.text.trim(),
        amount: _amountController.text.trim(),
        paymentReceipt: _paymentReceipt!,
      );

      _showSuccessDialog(response);
    } on ManualPaymentException catch (error) {
      customSnackbar(
        title: 'فشل',
        message: error.message,
        type: CustomSnackbarType.failed,
      );
    } catch (error) {
      customSnackbar(
        title: 'فشل',
        message: 'حدث خطأ أثناء إرسال الدفع. حاول مرة أخرى.',
        type: CustomSnackbarType.failed,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _showSuccessDialog(ManualPaymentResponseModel response) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: AppColors.cardBackgroundColor,
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            contentPadding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 12.h),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64.w,
                  height: 64.w,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColorLight,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    size: 38.sp,
                    color: AppColors.primaryColor,
                  ),
                ),
                SizedBox(height: 14.h),
                Text(
                  'تم إرسال الدفع بنجاح',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.titleTextColor,
                    fontSize: 19.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'تم استلام طلبك وسيتم مراجعته قريبًا.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.smallTextColor,
                    fontSize: 13.sp,
                  ),
                ),
                SizedBox(height: 18.h),
                _buildPaymentInfoRow('رقم الطلب', '${response.orderId}'),
                SizedBox(height: 8.h),
                _buildPaymentInfoRow('رقم الفاتورة', response.invoiceId),
                SizedBox(height: 8.h),
                _buildPaymentInfoRow('حالة الدفع', response.paymentStatus),
                SizedBox(height: 20.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Get.offAll(() => CustomPersistentBottomNavBar());
                    },
                    child: const Text(
                      'حسنًا، العودة للرئيسية',
                      style: TextStyle(
                        fontFamily: "BalooBhaijaan2",
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPaymentInfoRow(String label, String value) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.smallTextColor,
              fontSize: 12.sp,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: AppColors.titleTextColor,
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentDetails() {
    final String method = _selectedPaymentMethod!;
    final String methodLabel = _paymentMethods.firstWhere(
      (item) => item['value'] == method,
    )['label']!;
    final Map<String, String> details = _paymentDetails[method] ?? {};

    return Container(
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 10.h),
      decoration: BoxDecoration(
        color: AppColors.primaryColorLight,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: AppColors.primaryColor.withOpacity(0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 34.w,
                height: 34.w,
                decoration: BoxDecoration(
                  color: AppColors.cardBackgroundColor,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.account_balance_wallet_outlined,
                  color: AppColors.primaryColor,
                  size: 19.sp,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  'بيانات $methodLabel',
                  style: TextStyle(
                    color: AppColors.titleTextColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          ...details.entries.map(
            (entry) => Padding(
              padding: EdgeInsets.only(bottom: 6.h),
              child: _buildPaymentDetailRow(entry.key, entry.value),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'استخدم هذه البيانات لإتمام التحويل ثم ارفع صورة الإيصال أدناه.',
            style: TextStyle(
              color: AppColors.smallTextColor,
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentDetailRow(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundColor,
        borderRadius: BorderRadius.circular(9.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.smallTextColor,
                fontSize: 12.sp,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            flex: 3,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: AppColors.titleTextColor,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.titleTextColor),
        title: GlobalText(
          text: 'إرسال تحويل يدوي',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.titleTextColor,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 28.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'أدخل بيانات التحويل',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.smallTextColor,
                  ),
                ),
                SizedBox(height: 20.h),
                GlobalText(
                  text: 'طريقة الدفع',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.titleTextColor,
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackgroundColor,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.textFieldBorderColor),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: _selectedPaymentMethod,
                    decoration: const InputDecoration(border: InputBorder.none),
                    hint: const Text('اختر طريقة الدفع'),
                    items: _paymentMethods.map((method) {
                      return DropdownMenuItem<String>(
                        value: method['value'],
                        child: Text(method['label'] ?? ''),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedPaymentMethod = value;
                      });
                    },
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: _selectedPaymentMethod == null
                      ? const SizedBox.shrink()
                      : Padding(
                          key: ValueKey(_selectedPaymentMethod),
                          padding: EdgeInsets.only(top: 12.h),
                          child: _buildPaymentDetails(),
                        ),
                ),
                SizedBox(height: 14.h),
                GlobalText(
                  text: 'رقم الحساب أو رقم التحويل',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.titleTextColor,
                  ),
                ),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: _accountController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.cardBackgroundColor,
                    hintText: 'أدخل رقم الحساب أو التحويل',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide:
                          BorderSide(color: AppColors.textFieldBorderColor),
                    ),
                  ),
                ),
                SizedBox(height: 14.h),
                GlobalText(
                  text: 'المبلغ',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.titleTextColor,
                  ),
                ),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: _amountController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.cardBackgroundColor,
                    hintText: 'أدخل المبلغ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide:
                          BorderSide(color: AppColors.textFieldBorderColor),
                    ),
                  ),
                ),
                SizedBox(height: 14.h),
                GlobalText(
                  text: 'صورة الإيصال',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.titleTextColor,
                  ),
                ),
                SizedBox(height: 8.h),
                GestureDetector(
                  onTap: _pickReceiptImage,
                  child: Container(
                    height: 184.h,
                    decoration: BoxDecoration(
                      color: AppColors.cardBackgroundColor,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: AppColors.textFieldBorderColor),
                    ),
                    child: _paymentReceipt == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image_outlined,
                                size: 42.sp,
                                color: AppColors.inactiveIconColor,
                              ),
                              SizedBox(height: 8.h),
                              GlobalText(
                                text: 'اضغط لاختيار صورة الإيصال من المعرض',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: AppColors.inactiveIconColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(12.r),
                            child: Image.file(
                              _paymentReceipt!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 20.h),
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitManualPayment,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50.h),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: _isSubmitting
                      ? SizedBox(
                          height: 20.h,
                          width: 20.h,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : GlobalText(
                          text: 'إرسال الدفع',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontFamily: "BalooBhaijaan2",
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ],
            ),
          ),
          if (_isSubmitting)
            Container(
              color: Colors.black.withOpacity(0.25),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
