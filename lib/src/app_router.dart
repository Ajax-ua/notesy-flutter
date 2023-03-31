import 'package:go_router/go_router.dart';

import 'repos/repos.dart';
import 'screens/add_note/add_note.dart';
import 'screens/note_list/note_list.dart';
import 'screens/page_not_found/page_not_found.dart';
import 'screens/users/users.dart';
import 'tabs_builder.dart';

final GoRouter router = GoRouter(
  navigatorKey: AppRepository().navigatorKey,
  routes: [
    ShellRoute(
      builder: tabsBuilder,
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            child: NoteList()
          ),
        ),
        GoRoute(
          path: '/add-note',
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            child: AddNote()
          ),
        ),
        GoRoute(
          path: '/users',
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            child: Users()
          ),
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => const PageNotFound(),
);