import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'repos/repos.dart';
import 'shared/widgets/burger_menu.dart';

late String headerTitle;

Widget childPageBuilder (BuildContext context, GoRouterState state, Widget child) {
  final route = GoRouter.of(context).routerDelegate.currentConfiguration.last.route;
  final routeName = route is GoRoute ? route.name : null;

  String headerTitle = 'Notesy';
  if (routeName != null) {
    headerTitle = routeName;
  }

  return Scaffold(
    appBar: AppBar(
      title: Text(headerTitle),
      automaticallyImplyLeading: false,
      centerTitle: true,
      leading: BackButton(
        onPressed: () => RouterRepository().goBack(context),
      ),
      actions: const [
        BurgerMenu(),
      ],
    ),
    body: child,
  );
}
