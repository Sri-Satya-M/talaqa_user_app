import 'dart:async';

import 'package:dio/dio.dart';

class CacheInterceptor extends Interceptor {
  CacheInterceptor();

  var _cache = Map<Uri, Response>();

  @override
  Future onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    var segments = options.uri.pathSegments;
    if (options.method != 'GET') return handler.next(options);
    if (!segments.contains('products') && !segments.contains('categories')) {
      return handler.next(options);
    }
    Response? response = _cache[options.uri];
    if (response != null) {
      print("cache hit: ${options.uri} \n");
      return handler.resolve(response);
    }
    return handler.next(options);
  }

  @override
  Future onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    if (response.requestOptions.method != 'GET') return handler.next(response);
    var segments = response.requestOptions.uri.pathSegments;
    if (!segments.contains('products') && !segments.contains('categories')) {
      return handler.next(response);
    }
    _cache[response.requestOptions.uri] = response;
    handler.next(response);
  }

  @override
  Future onError(
    DioError err,
    ErrorInterceptorHandler handler,
  ) async {
    print('onError: $err');
    handler.next(err);
  }
}
