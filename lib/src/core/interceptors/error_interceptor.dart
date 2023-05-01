import 'dart:convert';

import 'package:http_interceptor/http_interceptor.dart';
import 'package:notesy_flutter/src/repos/app_repository.dart';

class ErrorInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    if (data.statusCode >= 400) {
      final decodedResponse = json.decode(data.body!);
      AppRepository().showToastr(message: decodedResponse['message']);
    }
    return data;
  }

}