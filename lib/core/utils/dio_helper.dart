import 'package:dio/dio.dart';
import '../constants/api_constants.dart';

class DioHelper {
  static late Dio dio;

  static void init() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        headers: ApiConstants.headers,
        connectTimeout: ApiConstants.connectionTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
      ),
    );

    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        logPrint: (obj) => print('🌐 DIO: $obj'),
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('📤 REQUEST[${options.method}] => PATH: ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('✅ RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (error, handler) {
          print('❌ ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}');
          print('❌ ERROR MESSAGE: ${error.message}');
          return handler.next(error);
        },
      ),
    );
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    try {
      dio.options.headers = {
        ...ApiConstants.headers,
        if (token != null) 'Authorization': 'Bearer $token',
      };

      final response = await dio.get(
        url,
        queryParameters: query,
      );
      return response;
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  static Future<Response> postData({
    required String url,
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    try {
      dio.options.headers = {
        ...ApiConstants.headers,
        if (token != null) 'Authorization': 'Bearer $token',
      };

      final response = await dio.post(
        url,
        data: data,
        queryParameters: query,
      );
      return response;
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  static Future<Response> putData({
    required String url,
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    try {
      dio.options.headers = {
        ...ApiConstants.headers,
        if (token != null) 'Authorization': 'Bearer $token',
      };

      final response = await dio.put(
        url,
        data: data,
        queryParameters: query,
      );
      return response;
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  static Future<Response> deleteData({
    required String url,
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    try {
      dio.options.headers = {
        ...ApiConstants.headers,
        if (token != null) 'Authorization': 'Bearer $token',
      };

      final response = await dio.delete(
        url,
        data: data,
        queryParameters: query,
      );
      return response;
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  static void _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        print('❌ Connection Timeout');
        break;
      case DioExceptionType.sendTimeout:
        print('❌ Send Timeout');
        break;
      case DioExceptionType.receiveTimeout:
        print('❌ Receive Timeout');
        break;
      case DioExceptionType.badResponse:
        print('❌ Bad Response: ${error.response?.statusCode}');
        print('❌ Response Data: ${error.response?.data}');
        break;
      case DioExceptionType.cancel:
        print('❌ Request Cancelled');
        break;
      case DioExceptionType.unknown:
        if (error.message?.contains('SocketException') ?? false) {
          print('❌ No Internet Connection');
        } else {
          print('❌ Unknown Error: ${error.message}');
        }
        break;
      default:
        print('❌ Unexpected Error');
    }
  }
}