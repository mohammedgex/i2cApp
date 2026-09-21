// ignore_for_file: non_constant_identifier_names, constant_identifier_names

class ApiEndpoint {
  static const String BASE_URL = "https://i2cteam.com/";

  static const String API_BASE_URL = '${BASE_URL}api';

  // Authentication URLs
  static const String loginUrl = '$API_BASE_URL/login';
  static const String registerUrl = '$API_BASE_URL/register';
  static const String forgetPasswordUrl = '$API_BASE_URL/forget-password';
  static const String resetPasswordUrl = '$API_BASE_URL/reset-password';
  static const String logoutUrl = '$API_BASE_URL/logout';
  static const String logoutFromAllDevicesUrl = '$API_BASE_URL/logout/all-app';
  static const String updateFcmTokenUrl = '$API_BASE_URL/update-fcm-token';
  static const String deleteAccountUrl = '$API_BASE_URL/delete-account';

  // Global User URLs
  static const String settingsUrl = '$API_BASE_URL/settings';
  static const String countriesUrl = '$API_BASE_URL/countries';
  static const String languageListUrl = '$API_BASE_URL/language-list';
  static const String currencyListUrl = '$API_BASE_URL/currency-list';
  static String multiLangualDataUrl(String code) {
    return '$API_BASE_URL/static-language/$code';
  }

  static const String courseLanguagesUrl = '$API_BASE_URL/course-languages';

  static String courseMainCategoriesUrl(
      {required String languageCode, int? limit}) {
    return '$API_BASE_URL/course-main-categories?language=ar&limit=$limit';
  }

  static String courseSubCategoriesUrl({
    required String main_category_slug,
    required String languageCode,
  }) {
    return '$API_BASE_URL/course-sub-categories/$main_category_slug?language=ar';
  }

  static String courseLevelsUrl({
    int? limit,
    required String languageCode,
  }) {
    return '$API_BASE_URL/course-levels?limit=$limit&language=ar';
  }

  // Courses URLs
  static String popularCoursesUrl({
    int? limit,
    required String currency,
  }) {
    return '$API_BASE_URL/popular-courses?limit=$limit&currency=$currency';
  }

  static String freshCoursesUrl({
    int? limit,
    required String currency,
  }) {
    return '$API_BASE_URL/fresh-courses?limit=$limit&currency=$currency';
  }

  static String searchCoursesUrl({
    int? limit,
    String? currency,
    String? search,
    String? main_category,
    String? sub_category,
    String? price,
    String? languages_code,
    String? levels,
    String? rating,
    String? page,
  }) {
    return '$API_BASE_URL/search-courses?limit=$limit&currency=$currency&search=$search&main_category=$main_category&sub_category=$sub_category&price=$price&languages=$languages_code&levels=$levels&rating=$rating&page=$page';
  }

  static String coursesUrl(
      {required String slug, required String currency, String? userId}) {
    return '$API_BASE_URL/course/$slug?currency=$currency&user_id=$userId';
  }

  static String freeLessonInfoUrl({required String lesson_id}) {
    return '$API_BASE_URL/course/free-lesson-info/$lesson_id';
  }

  static String courseReviewUrl(
      {required String course_slug, int? limit, int? page}) {
    return '$API_BASE_URL/course/reviews/$course_slug?page=$page?limit=$limit';
  }

  // Frontend URLs
  static String privecyPolicyUrl({required String languageCode}) {
    return '$API_BASE_URL/privacy-policy?language=ar';
  }

  static String termsAndConditionsUrl({required String languageCode}) {
    return '$API_BASE_URL/terms-and-conditions?language=ar';
  }

  static String faqUrl({
    required String languageCode,
    int? limit,
  }) {
    if (limit == null) {
      return '$API_BASE_URL/faqs?language=ar';
    } else {
      return '$API_BASE_URL/faqs?language=ar&limit=$limit';
    }
  }

  static const String onboardingUrl = '$API_BASE_URL/on-boarding-screen';

  // Dashboard Order URLs
  static String dashboardOrderUrl({
    required int limit,
    required String page,
  }) {
    return '$API_BASE_URL/orders?limit=$limit&page=$page';
  }

  static String dashboardOrderDetailsUrl({required String invoice_id}) {
    return '$API_BASE_URL/orders/:$invoice_id';
  }

  static String dashboardOrderInvoiceUrl({required String invoice_id}) {
    return '$API_BASE_URL/orders-invoice/:$invoice_id';
  }

  // Dashboard Review URLs
  static String dashboardReviewsUrl({
    required int limit,
    required String page,
  }) {
    return "$API_BASE_URL/reviews?limit=$limit&page=$page";
  }

  static String dashboardReviewsDetailUrl({required String id}) {
    return "$API_BASE_URL/reviews/$id";
  }

  static String dashboardReviewsDeleteUrl({required String id}) {
    return "$API_BASE_URL/reviews/$id";
  }

  // Dashboard Quiz URLs
  static String dashboardQuizUrl({
    required int limit,
    required String page,
  }) {
    return "$API_BASE_URL/quiz-attempts?limit=$limit&page=$page";
  }

  static String dashboardQuizDetailsUrl({required String id}) {
    return "$API_BASE_URL/quiz-attempts/:$id";
  }

  // Dashboard Enrolled Course URLs
  static String dashboardEnrolledCourseUrl({
    int? limit,
    required int page,
  }) {
    return "$API_BASE_URL/enrolled-courses?limit=$limit&page=$page";
  }

  static String checkStatusForDownlaodCertificate({required String slug}) {
    return "$API_BASE_URL/learning/$slug/progress";
  }

  static String downloadCertificateUrl({
    required String course_slug,
  }) {
    return "$API_BASE_URL/download-certificate/$course_slug";
  }

  // Dashboard Wishlist URLs
  static String dashboardWishlistUrl({
    int? limit,
    String? page,
  }) {
    return "$API_BASE_URL/wishlist-courses?limit=$limit&page=$page";
  }

  static String dashboardAddRemoveWishlistUrl({required String course_slug}) {
    return "$API_BASE_URL/add-remove-wishlist/$course_slug";
  }

  // Dashboard Learning Quiz URLs
  static String dashboardLearningQuizeUrl({
    required String course_slug,
    required String id,
  }) {
    return "$API_BASE_URL/learning/$course_slug/quiz/$id";
  }

  static String dashboardLearningQuizeResultUrl({
    required String course_slug,
    required String id,
  }) {
    return "$API_BASE_URL/learning/$course_slug/quiz-results/$id";
  }

  // QNA URLs
  static String qnaUrl({
    int? limit,
    required String course_slug,
    required String lesson_id,
    String? search,
    String? page,
  }) {
    if (search != null && page != null && limit != null) {
      return "$API_BASE_URL/questions/$course_slug/$lesson_id?search=$search&page=$page&limit=$limit";
    } else if (search != null) {
      return "$API_BASE_URL/questions/$course_slug/$lesson_id?search=$search";
    } else if (page != null) {
      return "$API_BASE_URL/questions/$course_slug/$lesson_id?page=$page";
    } else if (limit != null && page != null) {
      return "$API_BASE_URL/questions/$course_slug/$lesson_id?limit=$limit&page=$page";
    } else if (limit != null && search != null) {
      return "$API_BASE_URL/questions/$course_slug/$lesson_id?search=$search&limit=$limit";
    } else if (page != null && search != null) {
      return "$API_BASE_URL/questions/$course_slug/$lesson_id?search=$search&page=$page";
    } else if (limit != null) {
      return "$API_BASE_URL/questions/$course_slug/$lesson_id?limit=$limit";
    } else {
      return "$API_BASE_URL/questions/$course_slug/$lesson_id";
    }
  }

  static String addQuestionUrl({
    required String course_slug,
    required String lesson_id,
  }) {
    return "$API_BASE_URL/questions-create/$course_slug/$lesson_id";
  }

  static String deleteQuestionUrl({required String question_id}) {
    return "$API_BASE_URL/questions-destroy/$question_id";
  }

  static String addQuestionReplyUrl(
      {required String question_id, required String lesson_id}) {
    return "$API_BASE_URL/questions/replay/$lesson_id/$question_id";
  }

  static String deleteQuestionReplyUrl({required String reply_id}) {
    return "$API_BASE_URL/questions/replay/$reply_id";
  }

  // Dashboard Learning URLs
  static String dashboardLearningUrl({required String course_slug}) {
    return "$API_BASE_URL/learning/$course_slug";
  }

  static String dashboardLearningGetFileInfoUrl({
    required String course_slug,
    required String type,
    required String lesson_id,
  }) {
    return "$API_BASE_URL/learning/$course_slug/get-file-info/$type/$lesson_id";
  }

  static String dashboardLearningLessonCompleteUrl({
    required String lesson_id,
  }) {
    return "$API_BASE_URL/learning/make-lesson-complete/$lesson_id";
  }

  static String dashboardLearningAnnouncementUrl({required String slug}) {
    return "$API_BASE_URL/learning/$slug/announcements";
  }

  static String dashboardCartListUrl({required String currency}) {
    return "$API_BASE_URL/cart-list?currency=$currency";
  }

  static String dashboardAddToCartUrl({required String slug}) {
    return "$API_BASE_URL/add-to-cart/$slug";
  }

  static String dashboardRemoveCartUrl({required String slug}) {
    return "$API_BASE_URL/remove-from-cart/$slug";
  }

  static String paymentApiUrl(
      {required String method, required String currency}) {
    return "$API_BASE_URL/payment-api/$method?currency=$currency";
  }

  // payment URLs
  static String payemntMethodsListUrl = "$API_BASE_URL/payment-gateway-list";

  // Dashboard Profile URLs
  static const String dashboardProfileUrl = "$API_BASE_URL/profile";
  static const String dashboardProfilePictureUpdateUrl =
      "$API_BASE_URL/update-profile-picture";
  static const String dashboardProfileUpdateUrl =
      "$API_BASE_URL/update-profile";
  static const String dashboardProfileUpdateBioUrl = "$API_BASE_URL/update-bio";
  static const String dashboardProfileUpdatePasswordUrl =
      "$API_BASE_URL/update-password";
  static const String dashboardProfileUpdateAddressUrl =
      "$API_BASE_URL/update-address";
  static const String dashboardProfileUpdateSocialLinksUrl =
      "$API_BASE_URL/update-social-links";

  // Extra URLs
  static const String socialLinksUrl = "$API_BASE_URL/social-links";
  static const String contactUsUrl = "$API_BASE_URL/contact-us";
  static const String subscribeUsUrl = "$API_BASE_URL/subscribe-us";
}
