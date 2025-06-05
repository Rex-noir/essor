import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiClient {
  final Dio dio;

  static final ApiClient _instance =
      ApiClient._internal(
          Dio(
            BaseOptions(
              baseUrl: 'https://jsonplaceholder.typicode.com',
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
              headers: {'Content-Type': 'application/json'},
            ),
          ),
        )
        ..dio.interceptors.add(
          PrettyDioLogger(requestHeader: true, responseBody: true),
        );

  ApiClient._internal(this.dio);

  factory ApiClient() => _instance;
}
