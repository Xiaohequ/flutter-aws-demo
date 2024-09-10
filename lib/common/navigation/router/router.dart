import 'package:aws_demo/common/navigation/router/routes.dart';
import 'package:aws_demo/common/ui/notification_widget.dart';
import 'package:aws_demo/features/trip/ui/trips_list/trips_list_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: AppRoute.home.name,
      builder: (context, state) => const TripsListPage(),
    ),
    GoRoute(
      path: '/login',
      name: AppRoute.authentification.name,
      builder: (context, state) => const TripsListPage(),
    )
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text(state.error.toString()),
    ),
  ),
);