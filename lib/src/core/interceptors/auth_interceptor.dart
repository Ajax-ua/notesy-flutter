import 'package:http_interceptor/http_interceptor.dart';
import 'package:notesy_flutter/src/bloc/blocs.dart';

class AuthInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    final String token = AuthCubit().state.token ?? '';
    data.headers['Authorization'] = 'Bearer $token';
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    return data;
  }

}