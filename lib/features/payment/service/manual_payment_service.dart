import 'dart:typed_data';
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
      orderId: json['order_id'] is int
          ? json['order_id']
          : int.parse(json['order_id'].toString()),
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
    required Uint8List paymentReceiptBytes,
    required String paymentReceiptFileName,
  }) async {
    final String token = await SharedPrefUtil.get('token', '');
    final String url = '${ApiEndpoint.API_BASE_URL}/pay-via-bank';

    final FormData formData = FormData()
      ..fields.addAll([
        MapEntry('payment_method', paymentMethod),
        MapEntry('account_number', accountNumber),
      ])
      ..files.add(
        MapEntry(
          'payment_receipt',
          MultipartFile.fromBytes(
            paymentReceiptBytes,
            filename: paymentReceiptFileName,
          ),
        ),
      );

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

      final Map<String, dynamic>? responseData =
          response.data as Map<String, dynamic>?;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseData != null && responseData['status'] == true) {
          final Map<String, dynamic> data =
              Map<String, dynamic>.from(responseData['data'] ?? {});
          return ManualPaymentResponseModel.fromJson(data);
        }

        final String errorMessage = _extractErrorMessage(
          response.data,
          fallback: 'فشل إرسال طلب الدفع.',
        );
        throw ManualPaymentException(message: errorMessage);
      }

      throw ManualPaymentException(
          message: 'فشل الاتصال بالخادم. حاول مرة أخرى.');
    } on DioException catch (e) {
      final String errorMessage = _extractErrorMessage(
        e.response?.data,
        fallback: e.message ?? 'فشل إرسال الدفع.',
      );
      throw ManualPaymentException(message: errorMessage);
    } catch (e) {
      throw ManualPaymentException(message: e.toString());
    }
  }

  String _extractErrorMessage(
    Object? responseData, {
    required String fallback,
  }) {
    if (responseData is Map) {
      final String? message = responseData['message']?.toString();
      final Object? errors = responseData['errors'];

      if (errors is Map) {
        final List<String> details = [];
        errors.forEach((field, value) {
          final List<String> messages = value is Iterable
              ? value.map((item) => item.toString()).toList()
              : [value.toString()];
          details.add('$field: ${messages.join(', ')}');
        });

        if (details.isNotEmpty) {
          return [
            if (message != null && message.isNotEmpty) message,
            ...details,
          ].join('\n');
        }
      }

      if (message != null && message.isNotEmpty) {
        return message;
      }
    }

    if (responseData is String && responseData.isNotEmpty) {
      return responseData;
    }

    return fallback;
  }
}
