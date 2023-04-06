import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../bloc/blocs.dart';

String? authGuard(BuildContext context, GoRouterState state) {
  final bool isGuest = AuthCubit().state.isGuest!;
  if (isGuest) {
    return null;
  }

  return '/';
}