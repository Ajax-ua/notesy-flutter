import 'package:http_interceptor/http_interceptor.dart';

import '../../environments/environment.dart';

class BaseUrlInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    final String requestPath = data.baseUrl.split('://')[1];
    data.baseUrl = '${environment.apiUrl}/$requestPath';
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    return data;
  }

}