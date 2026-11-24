// الملف ده مسؤول عن تنفيذ كل طلبات الشبكة باستخدام مكتبة Dio
// زي POST و GET و PUT و DELETE وكمان بيتحكم في الـ headers زي Content-Type و Authorization Token
import 'package:graduation_project_flutter/core/routing/routes_export.dart';

import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class DioConsumer implements ApiConsumer {
  Dio? _refreshDio;
  late Dio dio;
  final CacheHelper? _cacheHelper;

  DioConsumer([this._cacheHelper]) {
    dio = Dio(
      BaseOptions(
        baseUrl: EndPoints.baseUrl,
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      ),
    );

    // ==================== Interceptors ====================
    dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) async {
          // جلب التوكن من الكاش بشكل تلقائي لو مش مبعوت يدوي
          if (options.headers["Authorization"] == null) {
            final token = _cacheHelper?.getToken();
            if (token != null) {
              options.headers["Authorization"] = "Bearer $token";
            }
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          final statusCode = e.response?.statusCode;

          // إذا انتهت صلاحية التوكن (401)، نحاول استخدام الـ refresh token
          if (statusCode == 401) {
            // IF GUEST, do not log out globally or redirect. Just return the 401 to the caller.
            if (_cacheHelper?.isGuestMode() == true) {
              return handler.next(_buildParsedError(e));
            }

            final refreshToken = _cacheHelper?.getRefreshToken();

            if (refreshToken != null) {
              _refreshDio ??= Dio(BaseOptions(baseUrl: EndPoints.baseUrl));
              try {
                final refreshResponse = await _refreshDio!.post(
                  EndPoints.refreshAccessToken,
                  data: {'refreshToken': refreshToken},
                );

                if (refreshResponse.statusCode == 200 &&
                    refreshResponse.data != null) {
                  final data =
                      refreshResponse.data['data'] ?? refreshResponse.data;
                  final newAccessToken = data['token'] ?? data['accessToken'];
                  final newRefreshToken = data['refreshToken'];

                  if (newAccessToken != null) {
                    await _cacheHelper?.saveToken(newAccessToken);
                    if (newRefreshToken != null) {
                      await _cacheHelper?.saveRefreshToken(newRefreshToken);
                    }

                    // Update header for the failed request
                    e.requestOptions.headers["Authorization"] =
                        "Bearer $newAccessToken";

                    // Retry the request with the new token
                    final retryResponse = await dio.fetch(e.requestOptions);
                    return handler.resolve(retryResponse);
                  }
                }
              } catch (_) {
                // فشل التجديد
              }
            }

            // مسح الجلسة وتوجيه المستخدم لشاشة تسجيل الدخول
            try {
              sl<SessionCubit>().logout();
              navigatorKey.currentState?.pushNamedAndRemoveUntil(
                Routes.authOptions,
                (route) => false,
              );
            } catch (_) {
              await _cacheHelper?.clearAuthData();
              navigatorKey.currentState?.pushNamedAndRemoveUntil(
                Routes.authOptions,
                (route) => false,
              );
            }
          }

          // For all other errors, parse the backend message and pass a clean error
          return handler.next(_buildParsedError(e));
        },
      ),
    );

    // Optional: Add logging interceptor for debugging
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        requestHeader: true,
      ),
    );
  }

  /// Parses the backend response body to extract a human-readable error message.
  /// Falls back to status-code-specific messages when the body is unavailable.
  DioException _buildParsedError(DioException e) {
    final statusCode = e.response?.statusCode;
    final responseData = e.response?.data;

    // Try to extract the server's message from the response JSON
    String? serverMessage;
    if (responseData is Map) {
      serverMessage =
          responseData['message']?.toString() ??
          responseData['error']?.toString() ??
          responseData['title']?.toString();
    } else if (responseData is String && responseData.isNotEmpty) {
      serverMessage = responseData;
    }

    // Build a user-friendly fallback based on status code
    final String fallback = switch (statusCode) {
      429 => "Please wait before requesting another code. Try again in a moment.",
      400 => "Invalid request. Please check your input.",
      403 => "You don't have permission to perform this action.",
      404 => "The requested resource was not found.",
      409 => "This action conflicts with existing data.",
      500 => "Server error. Please try again later.",
      _ => "Something went wrong. Please try again.",
    };

    final cleanMessage = serverMessage ?? fallback;

    // Return a new DioException with our clean message replacing the raw one
    return DioException(
      requestOptions: e.requestOptions,
      response: e.response,
      type: e.type,
      error: cleanMessage,
      message: cleanMessage,
    );
  }

  // ==================== POST ====================
  @override
  Future<Response> post(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    String? token,
  }) async {
    // If a token is passed explicitly, it overrides the one from CacheHelper
    final options = Options();
    if (token != null) {
      options.headers = {"Authorization": "Bearer $token"};
    }

    return await dio.post(
      endpoint,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  // ==================== GET ====================
  @override
  Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    String? token,
  }) async {
    final options = Options();
    if (token != null) {
      options.headers = {"Authorization": "Bearer $token"};
    }

    return await dio.get(
      endpoint,
      queryParameters: queryParameters,
      options: options,
    );
  }

  // ==================== PUT ====================
  @override
  Future<Response> put(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    String? token,
  }) async {
    final options = Options();
    if (token != null) {
      options.headers = {"Authorization": "Bearer $token"};
    }

    return await dio.put(
      endpoint,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  // ==================== DELETE ====================
  @override
  Future<Response> delete(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    String? token,
  }) async {
    final options = Options();
    if (token != null) {
      options.headers = {"Authorization": "Bearer $token"};
    }

    return await dio.delete(
      endpoint,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}
