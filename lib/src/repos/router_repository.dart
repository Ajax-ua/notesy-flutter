import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'app_repository.dart';

class RouterRepository {
  RouterRepository._() : super();
  static final RouterRepository _instance = RouterRepository._();
  factory RouterRepository() {
    return _instance;
  }

  final _navigatorKey = AppRepository().navigatorKey;

  navigate(String path) {
    GoRouter.of(_navigatorKey.currentContext!).go(path);
  }

  goBack(BuildContext context) {
    final sourceUrl = (GoRouterState.of(context).extra ?? '/') as String;
    context.canPop() ? context.pop() : context.go(sourceUrl);
  }
}