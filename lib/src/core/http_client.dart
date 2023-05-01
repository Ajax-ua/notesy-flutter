import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';

import 'interceptors/auth_interceptor.dart';
import 'interceptors/base_url_interceptor.dart';
import 'interceptors/error_interceptor.dart';

http.Client httpClient = InterceptedClient.build(
  interceptors: [
    BaseUrlInterceptor(),
    AuthInterceptor(),
    ErrorInterceptor(),
  ],
);