import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tsuzuki_connect/config/router/route_transitions.dart';
import 'package:tsuzuki_connect/presentation/screens/game_screen.dart';

/// Provider for the app router
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/game',
    debugLogDiagnostics: true,
    routerNeglect: true,
    routes: [
      // Game screen (main VN)
      GoRoute(
        path: '/game',
        name: 'game',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const GameScreen(),
          transitionsBuilder: fadeTransition,
        ),
      ),
    ],
    errorPageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Page not found',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => context.go('/game'),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
    ),
    redirect: (context, state) {
      // No redirects for now, but could add authentication checks here
      return null;
    },
  );
});
