import 'package:get/get.dart' as getx; // Alias GetX
import 'package:dio/dio.dart' as dio; // Alias Dio
import 'package:skill_grow/core/Global/api_endpoint.dart';
import 'package:skill_grow/core/Global/api_service.dart';
import 'package:skill_grow/core/Global/error_handler.dart';
import 'package:skill_grow/features/course/model/fresh_course_model.dart';

import '../../../core/Global/sharedPref.dart';

class FreshCourseConroller extends getx.GetxController {
  final ApiService _apiService = ApiService();
  var courses = <FreshCourseData>[].obs; // Observable list to store courses
  var isLoading = false.obs; // Observable to manage loading state
  var errorMessage = ''.obs; // Observable for error messages
  var currency_code = 'EGP';

  @override
  void onInit() async {
    super.onInit();
    currency_code = await SharedPrefUtil.get('currency_code', 'EGP');
    fetchCourses();
  }

  // Fetch courses data from API
  Future<void> fetchCourses() async {
    isLoading.value = true;
    errorMessage.value = ''; // Clear any previous error messages

    try {
      // Example URL - Replace with actual API endpoint
      String url = ApiEndpoint.freshCoursesUrl(currency: currency_code);

      // Fetch data using GET method
      dio.Response? response = await _apiService.getData(url: url);

      if (response != null && response.statusCode == 200) {
        // Parse the response data into CourseModel
        FreshCourseResponseModel courseModel =
            FreshCourseResponseModel.fromJson(response.data);
        courses.value =
            courseModel.data; // Update the courses list with fetched data
        print(courseModel.data[0].discount);
      } else {
        errorMessage.value = 'Failed to fetch data';
      }
    } catch (e) {
      errorMessage.value =
          'Error: ${e.toString()}'; // Handle error and show message
      GlobalErrorHandler.handleError(e); // Global error handler if required
    } finally {
      isLoading.value = false;
    }
  }
}
