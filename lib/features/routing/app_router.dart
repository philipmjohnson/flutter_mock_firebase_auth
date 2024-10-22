import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../authentication/data/firebase_auth_repository.dart';
import '../authentication/presentation/custom_profile_screen.dart';
import '../authentication/presentation/custom_sign_in_screen.dart';
import 'go_router_refresh_stream.dart';

part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

enum AppRoute {
  signIn,
  profile,
}

@riverpod
GoRouter goRouter(GoRouterRef ref) {
  // rebuild GoRouter when app startup state changes
  final authRepository = ref.watch(authRepositoryProvider);
  return GoRouter(
    initialLocation: '/signIn',
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final isLoggedIn = authRepository.currentUser != null;
      return (isLoggedIn) ? '/profile' : '/signIn';
    },
    refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges()),
    routes: [
      GoRoute(
        path: '/signIn',
        name: AppRoute.signIn.name,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: CustomSignInScreen(),
        ),
      ),
      GoRoute(
        path: '/profile',
        name: AppRoute.profile.name,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: CustomProfileScreen(),
        ),
      ),
    ],
  );
}
