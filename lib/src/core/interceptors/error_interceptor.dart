import 'dart:convert';

import 'package:go_router/go_router.dart';
import 'package:http_interceptor/http_interceptor.dart';

import '../../bloc/blocs.dart';
import '../../repos/repos.dart';

class ErrorInterceptor implements InterceptorContract {
  final _appRepository = AppRepository();

  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    if (data.statusCode >= 400) {
      final decodedResponse = json.decode(data.body!);
      final String message = decodedResponse['message'];

      // TODO: refactor token expiration condition when api is updated to return either specific status or specific bool property
      if (message.contains('Firebase ID token has expired')) {
        AuthCubit().logout();
        GoRouter.of(_appRepository.navigatorKey.currentContext!).go('/login');
        _appRepository.showToastr(message: 'Session expired. Please login');
      } else {
        _appRepository.showToastr(message: message);
      }
    }
    return data;
  }

}