import 'package:dio/dio.dart';

import '../config/env_config.dart';
import '../utils/app_logger.dart';

/// Configured [Dio] instance for any REST calls the app makes outside of
/// the Firebase SDKs (e.g. AI provider HTTP APIs, custom cloud functions).
class DioClient {
  DioClient() : dio = Dio(BaseOptions(
          baseUrl: EnvConfig.apiBaseUrl ?? '',
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 30),
          headers: {'Content-Type': 'application/json'},
        )) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          appLogger.d('--> ${options.method} ${options.uri}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          appLogger.d('<-- ${response.statusCode} ${response.requestOptions.uri}');
          handler.next(response);
        },
        onError: (error, handler) {
          appLogger.e('<-- ERROR ${error.requestOptions.uri}', error: error);
          handler.next(error);
        },
      ),
    );
  }

  final Dio dio;
}
