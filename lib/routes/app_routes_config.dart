import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

// screens
import "package:flytsocial/screens/profile.dart";
import "package:flytsocial/screens/home.dart";


class MyAppRouter {
  GoRouter router = GoRouter(routes: [
    GoRoute(
        name: 'home',
        path: '/',
        pageBuilder: (context, state) {
          return const MaterialPage(child: Home());
        }),
        GoRoute(
        name: 'profile',
        path: '/profile',
        pageBuilder: (context, state) {
          return const MaterialPage(child: Profile());
        })
  ]);
}
