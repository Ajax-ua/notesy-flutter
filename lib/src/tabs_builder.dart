import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:notesy_flutter/src/shared/widgets/burger_menu.dart';
import 'package:rxdart/subjects.dart';

import 'shared/resolvers/resolvers.dart';

class Tab {
  final String url;
  final int index;
  final IconData icon;

  Tab({
    required this.url,
    required this.index,
    required this.icon,
  });
}

final selectedIndex$ = ReplaySubject();
late String headerTitle;

Widget tabsBuilder (BuildContext context, GoRouterState state, Widget child) {
  final List<Tab> tabs = [
    Tab(
      index: 0,
      url: '/',
      icon: Icons.home,
    ),
    Tab(
      index: 2,
      url: '/users',
      icon: Icons.people,
    ),
  ];

  final int currentIndex = tabs.cast<Tab?>().firstWhere(
    (tab) => tab?.url == state.location,
    orElse: () => null,
  )?.index ?? 1;
  selectedIndex$.add(currentIndex);

  final route = GoRouter.of(context).routerDelegate.currentConfiguration.last.route;
  final routeName = route is GoRoute ? route.name : null;

  String headerTitle = 'Notesy';
  if (routeName != null) {
    headerTitle = routeName;
  }

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
        title: Text(headerTitle),
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () => GoRouter.of(context).go('/'),
        ),
        actions: const [
          BurgerMenu(),
        ],
      ),
      body: LoadTopicsResolver(builder: (_) => child),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: const Color(0xfff2f2f2),
        elevation: 1,
        notchMargin: 12,
        child: SizedBox(
          height: 56.0,
          child: IconTheme(
            data: IconThemeData(color: Theme.of(context).colorScheme.primary),
            child: StreamBuilder(
              stream: selectedIndex$,
              builder: (context, snapshot) {
                final selectedIndex = snapshot.data;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[...tabs.map((tab) {
                    final index = tab.index;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          child: Icon(tab.icon),
                          onTap: () {
                            selectedIndex$.add(index);
                            GoRouter.of(context).go(tab.url);
                          },
                        ),
                        if (selectedIndex == index)
                          acriveDot,
                        if (selectedIndex != index) 
                          const SizedBox(height: 5)
                      ],
                    );
                  })],
                );
              },
            )
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: 64,
        height: 64,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () {
              selectedIndex$.add(1);
              GoRouter.of(context).go('/add-note');
            },
            child: const Icon(Icons.add),
          ),
        ),
      ),
      floatingActionButtonLocation: fabLocation,
    ),
  );
}
