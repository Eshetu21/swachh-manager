import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kabadmanager/features/auth/screens/login_page.dart';
import 'package:kabadmanager/features/home/screens/home_page.dart';
import 'package:kabadmanager/features/splash/screens/splash_screen.dart';

import './router_constants.dart';

part 'routes.g.dart';

@RouteConstants.splashRoute
class SplashRoute extends GoRouteData {
  const SplashRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SplashScreen();
}

@RouteConstants.authRoute
class AuthRoute extends GoRouteData {
  const AuthRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const LoginPage();
}

@RouteConstants.homeRoute
class HomeRoute extends GoRouteData {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const HomePage();
}
