import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../bloc/blocs.dart';

String? tabsGuard(BuildContext context, GoRouterState state) {
  final bool isGuest = AuthCubit().state.isGuest!;
  if (isGuest) {
    return '/login';
  }

  return null;
}