import 'dart:io';

import 'package:dio/dio.dart';
import 'package:skill_grow/core/Global/sharedPref.dart';
import 'package:skill_grow/core/global/api_endpoint.dart';

class ManualPaymentResponseModel {
  final int orderId;
  final String invoiceId;
  final String paymentStatus;

  ManualPaymentResponseModel({
    required this.orderId,
    required this.invoiceId,
    required this.paymentStatus,
  });

  factory ManualPaymentResponseModel.fromJson(Map<String, dynamic> json) {
    return ManualPaymentResponseModel(
      orderId: json['order_id'] is int ? json['order_id'] : int.parse(json['order_id'].toString()),
      invoiceId: json['invoice_id']?.toString() ?? '',
      paymentStatus: json['payment_status']?.toString() ?? '',
    );
  }
}

class ManualPaymentException implements Exception {
  final String message;

  ManualPaymentException({required this.message});
}

class ManualPaymentService {
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(minutes: 1),
      receiveTimeout: const Duration(minutes: 1),
      responseType: ResponseType.json,
    ),
  );

  Future<ManualPaymentResponseModel> submitManualPayment({
    required String paymentMethod,
    required String accountNumber,
    required String amount,
    required File paymentReceipt,
  }) async {
    final String token = await SharedPrefUtil.get('token', '');
    final String url = '${ApiEndpoint.API_BASE_URL}/pay-via-bank';

    final String fileName = paymentReceipt.path.split(Platform.pathSeparator).last;

    final FormData formData = FormData.fromMap({
      'payment_method': paymentMethod,
      'account_number': accountNumber,
      'amount': amount,
      'payment_receipt': await MultipartFile.fromFile(
        paymentReceipt.path,
        filename: fileName,
      ),
    });

    try {
      final Response response = await _dio.post(
        url,
        data: formData,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          contentType: 'multipart/form-data',
        ),
      );

      final Map<String, dynamic>? responseData = response.data as Map<String, dynamic>?;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseData != null && responseData['status'] == true) {
          final Map<String, dynamic> data = Map<String, dynamic>.from(responseData['data'] ?? {});
          return ManualPaymentResponseModel.fromJson(data);
        }

        final String errorMessage = responseData?['message']?.toString() ?? 'فشل إرسال طلب الدفع.';
        throw ManualPaymentException(message: errorMessage);
      }

      throw ManualPaymentException(message: 'فشل الاتصال بالخادم. حاول مرة أخرى.');
    } on DioException catch (e) {
      final String errorMessage = e.response?.data['message']?.toString() ?? e.message ?? 'فشل إرسال الدفع.';
      throw ManualPaymentException(message: errorMessage);
    } on SocketException {
      throw ManualPaymentException(message: 'لا يوجد اتصال بالإنترنت. تحقق من الشبكة وحاول مرة أخرى.');
    } catch (e) {
      throw ManualPaymentException(message: e.toString());
    }
  }
}
