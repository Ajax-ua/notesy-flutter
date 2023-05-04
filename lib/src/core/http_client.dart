import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';

import 'interceptors/auth_interceptor.dart';
import 'interceptors/base_url_interceptor.dart';
import 'interceptors/error_interceptor.dart';

// class HttpClient extends http.BaseClient {
//   final Map<String, String>? _defaultHeaders;
//   final http.Client _httpClient = http.Client();

//   HttpClient([this._defaultHeaders]);

//   @override
//   Future<http.StreamedResponse> send(http.BaseRequest request) {
//     return _httpClient.send(request);
//   }

//   @override
//   Future<http.Response> get(url, {Map<String, String>? headers}) {
//     return _httpClient.get(url, headers: _mergedHeaders(headers));
//   }

//   @override
//   Future<http.Response> post(url, {Map<String, String>? headers, dynamic body, Encoding? encoding}) {
//     return _httpClient.post(url, headers: _mergedHeaders(headers), body: body, encoding: encoding);
//   }

//   @override
//   Future<http.Response> patch(url, {Map<String, String>? headers, dynamic body, Encoding? encoding}) {
//     return _httpClient.patch(url, headers: _mergedHeaders(headers), body: body, encoding: encoding);
//   }

//   @override
//   Future<http.Response> put(url, {Map<String, String>? headers, dynamic body, Encoding? encoding}) {
//     return _httpClient.put(url, headers: _mergedHeaders(headers), body: body, encoding: encoding);
//   }

//   @override
//   Future<http.Response> head(url, {Map<String, String>? headers}) {
//     return _httpClient.head(url, headers: _mergedHeaders(headers));
//   }

//   @override
//   Future<http.Response> delete(
//     url, 
//     {Object? body, Encoding? encoding, Map<String, String>? headers}
//   ) {
//     return _httpClient.delete(url, headers: _mergedHeaders(headers));
//   }

//   Map<String, String> _mergedHeaders(Map<String, String>? headers) =>
//       {...?_defaultHeaders, ...?headers};

// } 

http.Client httpClient = InterceptedClient.build(
  interceptors: [
    BaseUrlInterceptor(),
    AuthInterceptor(),
    ErrorInterceptor(),
  ],
);