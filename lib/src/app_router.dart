import 'package:go_router/go_router.dart';

import 'auth_builder.dart';
import 'repos/repos.dart';
import 'screens/add_note/add_note.dart';
import 'screens/login/login.dart';
import 'screens/note_list/note_list.dart';
import 'screens/page_not_found/page_not_found.dart';
import 'screens/signup/signup.dart';
import 'screens/users/users.dart';
import 'shared/guards/guards.dart';
import 'tabs_builder.dart';

final GoRouter router = GoRouter(
  navigatorKey: AppRepository().navigatorKey,
  routes: [
    ShellRoute(
      builder: authBuilder,
      routes: [
        GoRoute(
          path: '/signup',
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            child: Signup(),
          ),
          redirect: authGuard,
        ),
        GoRoute(
          path: '/login',
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            child: Login(),
          ),
          redirect: authGuard,
        ),
      ],
    ),
    ShellRoute(
      builder: tabsBuilder,
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            child: NoteList()
          ),
          redirect: tabsGuard,
        ),
        GoRoute(
          path: '/add-note',
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            child: AddNote()
          ),
          redirect: tabsGuard,
        ),
        GoRoute(
          path: '/users',
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            child: Users()
          ),
          redirect: tabsGuard,
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => const PageNotFound(),
);