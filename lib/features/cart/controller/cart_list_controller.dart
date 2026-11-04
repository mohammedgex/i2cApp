import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:skill_grow/core/Global/api_endpoint.dart';
import 'package:skill_grow/core/Global/response_model.dart';
import '../../../core/Global/api_service.dart';
import '../../../core/Global/sharedPref.dart';
import '../../../core/widgets/snackbar.dart';
import '../model/cart_list_model.dart';

class CartListController extends GetxController {
  final ApiService _apiService = ApiService();

  var cartData = CartData(totalQty: 0, totalAmount: '', cartCourses: []).obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var currency_code = 'EGP';
  var isDeleting = false.obs;

  @override
  void onInit() async {
    currency_code = await SharedPrefUtil.get('currency_code', 'EGP');
    super.onInit();
    fetchCartData();
  }

  // Fetch cart data
  Future<void> fetchCartData() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      dio.Response? response = await _apiService.getData(
          url: ApiEndpoint.dashboardCartListUrl(currency: currency_code),
          requiresAuth: true);

      if (response != null && response.statusCode == 200) {
        var jsonData = response.data;
        print("Cart Data: $jsonData");
        cartData.value = CartData.fromJson(jsonData['data']);
      } else {
        errorMessage.value = 'Failed to load cart data';
      }
    } catch (e) {
      errorMessage.value = 'Error: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> removeFromCart(String slug) async {
    isDeleting.value = true;
    print("Removing Slug: $slug");

    try {
      dio.Response? response = await _apiService.deleteData(
        url: ApiEndpoint.dashboardRemoveCartUrl(slug: slug),
        requiresAuth: true,
      );

      if (response != null &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        final cartResponse = GlobalResponseModel.fromJson(response.data);

        // **REMOVE ITEM FROM LOCAL CART LIST**
        cartData.update((cart) {
          cart?.cartCourses.removeWhere((course) => course.slug == slug);
        });

        fetchCartData();

        customSnackbar(
          title: "Success",
          message: cartResponse.message,
          type: CustomSnackbarType.success,
        );
      } else {
        print("Error: ${response?.data}");
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isDeleting.value = false;
    }
  }
}
