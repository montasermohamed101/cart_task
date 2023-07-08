import 'dart:convert';
import 'package:dio/dio.dart';

class NetworkManager {
  final Dio _dio;
  const NetworkManager(this._dio);

  Future<Response<T>> request<T>(
      RequestMethod method,
      String url, {
        Map<String, dynamic>? data,
        Map<String, dynamic>? headers,
        Map<String, dynamic>? queryParameters,
        Function(int count, int total)? onSendProgress,
      }) {
    return _dio.request<T>(
      url,
      data: data,
      queryParameters: queryParameters,
      options: Options(
        method: method.value,
        headers: headers,
      ),
      onSendProgress: onSendProgress,
    );
  }
}

enum RequestMethod { get, head, post, put, delete, connect, options, trace, patch }

extension RequestMethodX on RequestMethod {
  String get value => _getEnumValue(this).toUpperCase();
}

String _getEnumValue(e) => e.toString().split('.').last;