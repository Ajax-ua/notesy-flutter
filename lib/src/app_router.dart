import 'package:go_router/go_router.dart';
import 'package:notesy_flutter/src/child_page_builder.dart';

import 'auth_builder.dart';
import 'bloc/utils/multi_bloc_resolver.dart';
import 'environments/environment.dart';
import 'repos/repos.dart';
import 'screens/add_note/add_note.dart';
import 'screens/edit_note/edit_note.dart';
import 'screens/login/login.dart';
import 'screens/feed/feed.dart';
import 'screens/note_details/note_details.dart';
import 'screens/page_not_found/page_not_found.dart';
import 'screens/signup/signup.dart';
import 'screens/user_profile/user_profile.dart';
import 'screens/users/users.dart';
import 'shared/guards/guards.dart';
import 'shared/resolvers/resolvers.dart';
import 'tabs_builder.dart';

final GoRouter router = GoRouter(
  navigatorKey: AppRepository().navigatorKey,
  debugLogDiagnostics: !environment.production,
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
            child: LoadNotesResolver(
              builder: (_) => Feed(),
            ),
          ),
          redirect: isLoggedInGuard,
        ),
        GoRoute(
          name: 'New Note',
          path: '/add-note',
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            child: AddNote()
          ),
          redirect: isLoggedInGuard,
        ),
        GoRoute(
          name: 'Users',
          path: '/users',
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            child: LoadUsersResolver(
              builder: (_) => Users(),
            ) 
          ),
          redirect: isLoggedInGuard,
        ),
      ],
    ),
    ShellRoute(
      builder: childPageBuilder,
      routes: [
        GoRoute(
          path: '/notes/:noteId',
          builder:(context, state) {
            return MultiBlocResolver(
              cubitFactories: [
                LoadTopicsResolver.factory(),
                LoadNoteResolver.factory(state.params['noteId']!),
              ],
              builder: (data) => NoteDetails(),
            );
          },
          redirect: isLoggedInGuard,
        ),
        GoRoute(
          name: 'Edit Note',
          path: '/notes/:noteId/edit',
          builder: (context, state) {
            final String noteId = state.params['noteId']!;
            return MultiBlocResolver(
              cubitFactories: [
                LoadTopicsResolver.factory(),
                LoadNoteResolver.factory(noteId),
              ],
              builder: (data) => EditNote(),
              isBuiltOnce: true,
            );
          },
          redirect: isLoggedInGuard,
        ),
      ],
    ),
    GoRoute(
      path: '/user/:userId',
      builder: (context, state) {
        final String userId = state.params['userId']!;
        return MultiBlocResolver(
          cubitFactories: [
            LoadUserResolver.factory(userId),
            LoadNotesResolver.factory(reset: true, userId: userId),
            LoadTopicsResolver.factory(),
          ],
          builder: (_) => UserProfile(),
        );
      },
      redirect: isLoggedInGuard,
    ),
  ],
  errorBuilder: (context, state) => const PageNotFound(),
);