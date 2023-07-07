import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_test_flutter_1/UI/form_view.dart';
import 'package:proyecto_test_flutter_1/UI/main_view.dart';
import 'package:proyecto_test_flutter_1/UI/people_view.dart';
import 'package:proyecto_test_flutter_1/UI/welcome_view.dart';

import '../Misc/constants.dart';

final GlobalKey<NavigatorState> _rootNavKey = GlobalKey();
final GlobalKey<NavigatorState> _shellNavKey = GlobalKey();

final router = GoRouter(navigatorKey: _rootNavKey, routes: [
  GoRoute(
    path: RoutePaths.welcomePage,
    name: RouteNames.welcomePage,
    builder: (context, state) => const WelcomeView(),
  ),
  ShellRoute(
      navigatorKey: _shellNavKey,
      builder: (context, state, child) => MainView(child),
      routes: [
        GoRoute(
          path: RoutePaths.peoplePage,
          name: RouteNames.peoplePage,
          builder: (context, state) => PeopleView(),
        ),
        GoRoute(
          path: RoutePaths.formPage,
          name: RouteNames.formPage,
          builder: (context, state) => const PersonFormView(),
        ),
      ])
]);
