import 'package:get/get.dart' as getx; // Alias GetX
import 'package:dio/dio.dart' as dio; // Alias Dio
import 'package:skill_grow/core/Global/api_endpoint.dart';
import 'package:skill_grow/core/Global/api_service.dart';
import 'package:skill_grow/core/Global/error_handler.dart';
import 'package:skill_grow/core/Global/response_model.dart';
import 'package:skill_grow/core/widgets/snackbar.dart';
import 'package:skill_grow/features/course/model/wish_list_model.dart';

import '../../../core/Global/sharedPref.dart';

class WishListController extends getx.GetxController {
  final ApiService _apiService = ApiService();
  var wishList =
      <WishListModel>[].obs; // Observable list to store wishlist items
  var isLoading = false.obs; // Observable to manage loading state
  var errorMessage = ''.obs; // Observable for error messages
  var currencyCode = 'EGP'.obs; // Observable for currency code
  var isDeleting = false.obs;
  @override
  void onInit() async {
    super.onInit();
    await _initializeCurrencyCode();
    await fetchCourses();
  }

  // Initialize currency code from shared preferences
  Future<void> _initializeCurrencyCode() async {
    currencyCode.value = await SharedPrefUtil.get('currency_code', 'EGP');
  }

  // Fetch wishlist data from API
  Future<void> fetchCourses() async {
    isLoading.value = true;
    errorMessage.value = ''; // Clear any previous error messages

    try {
      String url = ApiEndpoint.dashboardWishlistUrl();

      // Fetch data using GET method
      dio.Response? response = await _apiService.getData(
        url: url,
        showSnackbar: false,
      );

      if (response != null && response.statusCode == 200) {
        // Parse the response data into WishListResponseModel
        WishListResponseModel wishListResponse =
            WishListResponseModel.fromJson(response.data);
        wishList.value = wishListResponse.data; // Update the wishlist
      } else {
        errorMessage.value = 'Failed to fetch wishlist data';
      }
    } catch (e) {
      errorMessage.value = 'Error: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  // Remove an item from the wishlist
  Future<void> removeFromWishlist(String slug) async {
    isDeleting.value = true;
    try {
      final response = await _apiService.getData(
        url: ApiEndpoint.dashboardAddRemoveWishlistUrl(course_slug: slug),
        requiresAuth: true,
      );
      print(response);

      if (response == null) {
        throw Exception('No response received from the server.');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final wishListResponse = GlobalResponseModel.fromJson(response.data);

        // Remove the item from the local wishlist
        wishList.removeWhere((item) => item.slug == slug);

        // Show success message
        customSnackbar(
          title: "Success",
          message: wishListResponse.message,
          type: CustomSnackbarType.success,
        );
      } else {
        throw Exception(
            'Failed to remove item from wishlist. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      errorMessage.value = 'Error: ${e.toString()}';
      GlobalErrorHandler.handleError(e);
    } finally {
      isDeleting.value = false;
    }
  }
}
