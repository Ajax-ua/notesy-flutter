import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'bloc/blocs.dart';
import 'shared/resolvers/resolvers.dart';

Widget tabsBuilder (BuildContext context, GoRouterState state, Widget child) {
  int selectedIndex = 0;
  const FloatingActionButtonLocation fabLocation = FloatingActionButtonLocation.centerDocked;
  final acriveDot = Container(
    height: 5,
    width: 5,
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.primary,
      shape: BoxShape.circle,
    ),
  );

  return DefaultTabController(
    length: 3,
    child: Scaffold(
      appBar: AppBar(
        title: const Text('Notesy'),
        automaticallyImplyLeading: false,
        // backgroundColor: const Color(0xff5808e5),
        centerTitle: true,
        // toolbarHeight: 40,
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () => GoRouter.of(context).go('/'),
        ),
        actions: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                child: const Text('Logout'),
                onTap: () async {
                  await AuthCubit().logout();
                  GoRouter.of(context).go('/login');
                },
              ),
              const SizedBox(width: 15),
            ],
          ),
        ],
      ),
      body: LoadTopicsResolver(builder: (_) => child),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: const Color(0xfff2f2f2),
        child: SizedBox(
          height: 56.0,
          child: IconTheme(
            data: IconThemeData(color: Theme.of(context).colorScheme.primary),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column (
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      child: const Icon(Icons.home),
                      onTap: () {
                        selectedIndex = 0;
                        GoRouter.of(context).go('/');
                      },
                    ),
                    if (selectedIndex == 0)
                      acriveDot
                  ],
                ),
                Column (
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.people),
                      onPressed: () {
                        selectedIndex = 2;
                        GoRouter.of(context).go('/users');
                      },
                    ),
                    if (selectedIndex == 2)
                      acriveDot
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          selectedIndex = 1;
          GoRouter.of(context).go('/add-note');
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: fabLocation,
    ),
  );
}
