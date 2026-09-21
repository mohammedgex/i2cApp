import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skill_grow/core/colors/app_colors.dart';
import 'package:skill_grow/core/widgets/custom_rating_bar.dart';
import 'package:skill_grow/core/widgets/texts.dart';
import 'package:skill_grow/features/mulit_langual_data/controller/multi_langual_data_controller.dart';

class StudentReviewsSection extends StatefulWidget {
  const StudentReviewsSection({super.key});

  @override
  State<StudentReviewsSection> createState() => _StudentReviewsSectionState();
}

class _StudentReviewsSectionState extends State<StudentReviewsSection> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentPage = 0;

  final List<_StudentReview> _reviews = const [
    _StudentReview(
      name: 'كريم محمود',
      course: 'دورة صيانة الموبايل',
      avatarUrl: 'https://i.pravatar.cc/150?img=12',
      comment:
          'بصراحة المهندس هاني شرحه جامد جدًا، وبيوصل المعلومة بطريقة بسيطة من غير تعقيد. أنا كنت فاكر الموضوع صعب بس مع الشرح والتطبيق بدأت أفهم الدنيا واحدة واحدة.',
      rating: 5.0,
    ),
    _StudentReview(
      name: 'عبدالله العتيبي',
      course: 'دورة احتراف صيانة الجوال',
      avatarUrl: 'https://i.pravatar.cc/150?img=33',
      comment:
          'صراحة من أفضل التجارب التعليمية اللي مريت فيها، شرح المهندس هاني واضح جدًا وتعاملهم راقي. استفدت بشكل كبير وحسيت إن المحتوى مرتب والتطبيق العملي فرق معي كثير.',
      rating: 5.0,
    ),
    _StudentReview(
      name: 'مصطفى الكعبي',
      course: 'دورة أعطال الموبايل المتقدمة',
      avatarUrl: 'https://i.pravatar.cc/150?img=68',
      comment:
          'بصراحة المهندس هاني ما قصر ويانا، شرحه واضح وسلس ويخليك تفهم المعلومة من أول مرة. والأكاديمية تعاملهم كلش زين، واستفاديت منهم هواي وأنصح أي واحد يريد يتعلم بشكل صحيح يجرب وياهم.',
      rating: 5.0,
    ),
    _StudentReview(
      name: 'محمد إبراهيم',
      course: 'دورة صيانة الموبايل العملية',
      avatarUrl: 'https://i.pravatar.cc/150?img=15',
      comment:
          'تجربتي مع I2C كانت حلوة جدًا، والمهندس هاني بجد بيهتم إنك تفهم مش تحفظ وخلاص. أي حاجة كانت بتقف معايا كنت بسأل وبلاقي شرح ومتابعة، ربنا يكرمه بجد.',
      rating: 5.0,
    ),
  ];

  final MultiLangualDataController _multiLangualDataController =
      Get.put(MultiLangualDataController());

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLTR = _multiLangualDataController.isLTR.value;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: TextDirection.rtl,
        children: [
          GlobalText(
            text: 'آراء طلابنا',
            softWrap: true,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: AppColors.titleTextColor,
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
          SizedBox(height: 6.sp),
          GlobalText(
            text: 'تجارب حقيقية من طلاب دورات صيانة الموبايل',
            softWrap: true,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: AppColors.smallTextColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 14.sp),
          SizedBox(
            height: 172.sp,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _reviews.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                final review = _reviews[index];
                return _buildReviewCard(review, isLTR);
              },
            ),
          ),
          SizedBox(height: 8.sp),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _reviews.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                height: 8.h,
                width: _currentPage == index ? 18.w : 8.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.r),
                  color: _currentPage == index
                      ? AppColors.primaryColor
                      : AppColors.inactiveIconColor.withOpacity(0.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(_StudentReview review, bool isLTR) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, child) {
        double value = 1.0;
        if (_pageController.position.haveDimensions) {
          final currentPage =
              _pageController.page ?? _pageController.initialPage.toDouble();
          value = currentPage - _currentPage;
          value = (1 - (value.abs() * 0.15)).clamp(0.85, 1.0).toDouble();
        }
        return Transform.scale(scale: value, child: child);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 6.sp),
        padding: EdgeInsets.all(14.sp),
        decoration: BoxDecoration(
          color: AppColors.cardBackgroundColor,
          borderRadius: BorderRadius.circular(14.sp),
          border: Border.all(color: AppColors.textFieldBorderColor),
        ),
        child: Column(
          crossAxisAlignment:
              isLTR ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            Row(
              textDirection: isLTR ? TextDirection.ltr : TextDirection.rtl,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _Avatar(
                    imageUrl:
                        "https://static.vecteezy.com/system/resources/thumbnails/028/149/251/small/3d-user-profile-icon-png.png"),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: isLTR
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GlobalText(
                        text: review.name,
                        softWrap: true,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.titleTextColor,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      GlobalText(
                        text: review.course,
                        softWrap: true,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.smallTextColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: GlobalText(
                text: review.comment,
                softWrap: true,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.smallTextColor,
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.w400,
                  height: 1.45,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// صورة الأفاتار الدائرية — لو الصورة مش متاحة بتظهر أيقونة شخص
class _Avatar extends StatelessWidget {
  final String? imageUrl;

  const _Avatar({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42.w,
      width: 42.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
      ),
      child: ClipOval(
        child: (imageUrl != null && imageUrl!.isNotEmpty)
            ? Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return _fallback();
                },
                errorBuilder: (_, __, ___) => _fallback(),
              )
            : _fallback(),
      ),
    );
  }

  Widget _fallback() {
    return Container(
      color: AppColors.primaryColorLight,
      alignment: Alignment.center,
      child: Icon(
        Icons.person_rounded,
        size: 24.sp,
        color: AppColors.primaryColor,
      ),
    );
  }
}

class _StudentReview {
  final String name;
  final String course;
  final String comment;
  final double rating;
  final String? avatarUrl;

  const _StudentReview({
    required this.name,
    required this.course,
    required this.comment,
    required this.rating,
    this.avatarUrl,
  });
}
