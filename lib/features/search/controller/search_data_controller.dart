import 'package:get/get.dart' as getx; // Alias GetX
import 'package:dio/dio.dart' as dio; // Alias Dio
import 'package:get/get.dart';
import 'package:skill_grow/core/Global/api_endpoint.dart';
import 'package:skill_grow/core/Global/api_service.dart';
import 'package:skill_grow/core/Global/error_handler.dart';
import '../../../core/Global/sharedPref.dart';
import '../model/search_result_model.dart'; // Ensure this file contains the updated model

class SearchDataController extends getx.GetxController {
  final ApiService _apiService = ApiService();
  var searchResults = <Course>[].obs; // Observable list to store courses
  var isLoading = false.obs; // Observable to manage loading state
  var errorMessage = ''.obs; // Observable for error messages
  var page = 1.obs; // Current page number
  var hasMore = true.obs; // Whether there are more items to load

  // Fetch courses data from API
  Future<void> fetchSearchData({
    String search = "",
    required String main_category,
    String? sub_category = "",
    String price = "",
    String languages_code = "",
    String levels = "",
    String rating = "",
    bool loadMore = false, // Whether to load more data or refresh the list
  }) async {
    if (isLoading.value) return; // Prevent multiple simultaneous requests

    if (!loadMore) {
      page.value = 1; // Reset page number if not loading more
      hasMore.value = true; // Reset hasMore flag
      searchResults.clear(); // Clear existing results
    }

    var currencyCode = await SharedPrefUtil.get('currency_code', 'EGP');
    isLoading.value = true;
    errorMessage.value = ''; // Clear any previous error messages

    try {
      String url = ApiEndpoint.searchCoursesUrl(
        currency: currencyCode,
        search: search,
        main_category: main_category,
        sub_category: sub_category,
        price: price,
        languages_code: languages_code,
        levels: levels,
        rating: rating,
        limit: 10, // Number of items per page
        page: page.value.toString(), // Current page number
      );

      dio.Response? response = await _apiService.getData(
        url: url,
        requiresAuth: false,
        showSnackbar: false,
      );

      if (response != null &&
          response.statusCode == 200 &&
          response.data != null) {
        final responseData = response.data;
        final searchResultResponse =
            SearchResultResponseModel.fromJson(responseData);

        if (loadMore) {
          searchResults.addAll(searchResultResponse.data);
        } else {
          searchResults.value = searchResultResponse.data;
        }

        // Check if there are more items to load
        if (searchResultResponse.data.length < 10) {
          hasMore.value = false; // No more data to load
        } else {
          page.value++; // Increment page number for the next load
        }
      } else {
        hasMore.value = false;
        errorMessage.value = 'Failed to fetch data: ${response?.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Error: ${e.toString()}';
      GlobalErrorHandler.handleError(e);
    } finally {
      isLoading.value = false; // Ensure loading state is reset
    }
  }
}
