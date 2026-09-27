import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:skill_grow/core/Global/api_endpoint.dart';
import '../../../core/Global/api_service.dart';
import '../model/video_file_model.dart';

class VideoPlayController extends GetxController {
  RxMap initialVideoDetails = {}.obs;

  final ApiService _apiService = ApiService();

  var isLoading = false.obs;
  var videoFile = Rxn<VideoFileResponseModel>();

  // @override
  // void onInit() {
  //   super.onInit();
  //   fetchVideoFile( slug: initialVideoDetails['slug'].toString(),
  //           type: initialVideoDetails['type'].toString(),
  //           id: initialVideoDetails['id'].toString());
  // }

  Future<void> fetchVideoFile(
      {required String id, required String slug, required String type}) async {
    isLoading.value = true;

    try {
      dio.Response? response = await _apiService.getData(
          url: ApiEndpoint.dashboardLearningGetFileInfoUrl(
        course_slug: slug,
        type: type,
        lesson_id: id,
      ));
      print(
          "📡 Fetching video file for Lesson ID: ${ApiEndpoint.dashboardLearningGetFileInfoUrl(
        course_slug: slug,
        type: type,
        lesson_id: id,
      )}");
      print(response!.statusCode);
      print("data: ${response.data}");

      if (response.data != null) {
        videoFile.value = VideoFileResponseModel.fromJson(response.data);
      }
    } catch (e) {
      print("Error fetching video file: $e");
    } finally {
      isLoading.value = false;
    }
  }
}

class FreeVideoPlayController extends GetxController {
  RxMap initialVideoDetails = {}.obs;

  final ApiService _apiService = ApiService();

  var isLoading = false.obs;
  var videoFile = Rxn<FreeVideoFileResponseModel>();

  // @override
  // void onInit() {
  //   super.onInit();
  //   fetchVideoFile( slug: initialVideoDetails['slug'].toString(),
  //           type: initialVideoDetails['type'].toString(),
  //           id: initialVideoDetails['id'].toString());
  // }

  Future<void> fetchVideoFile({required String id}) async {
    await _fetchVideoFile(
      url: ApiEndpoint.freeLessonInfoUrl(lesson_id: id),
    );
  }

  Future<void> fetchEnrolledLessonFile({
    required String id,
    required String slug,
    required String type,
  }) async {
    await _fetchVideoFile(
      url: ApiEndpoint.dashboardLearningGetFileInfoUrl(
        course_slug: slug,
        type: type,
        lesson_id: id,
      ),
    );
  }

  Future<void> _fetchVideoFile({required String url}) async {
    isLoading.value = true;

    try {
      final dio.Response? response = await _apiService.getData(url: url);
      final responseData = response?.data;

      if (responseData != null) {
        videoFile.value = FreeVideoFileResponseModel.fromJson(responseData);
      }
    } catch (e) {
      print("Error fetching video file: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
