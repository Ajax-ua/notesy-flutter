import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import '../../bloc/blocs.dart';

enum MenuItem {
  myNotes,
  logout,
}

class BurgerMenu extends StatelessWidget {
  const BurgerMenu({ super.key });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuItem>(
      offset: const Offset(0, 50),
      icon: const Icon(Icons.menu_rounded),
      onSelected: (MenuItem result) async {
        final String userId = AuthCubit().state.user!.uid;
        switch (result) {
          case MenuItem.myNotes:
          GoRouter.of(context).location;
            GoRouter.of(context).go('/user/$userId', extra: GoRouter.of(context).location);
            break;
          case MenuItem.logout:
            await AuthCubit().logout();
            GoRouter.of(context).go('/login');
            break;
        }
      },
      itemBuilder: (BuildContext context) => [
        const PopupMenuItem<MenuItem>(
          value: MenuItem.myNotes,
          child: Text('My notes'),
        ),
        const PopupMenuItem<MenuItem>(
          value: MenuItem.logout,
          child: Text('Logout'),
        ),
      ],
    );
  }
}
