import 'package:go_router/go_router.dart';
import 'package:kabadmanager/core/router/routes.dart';

class RouteConstants {
  static const splashRoute =
      TypedGoRoute<SplashRoute>(path: '/', name: 'splash');

  static const homeRoute =
      TypedGoRoute<HomeRoute>(path: '/home', name: 'home', routes: []);

  static const unAuthorizedRoute = TypedGoRoute<UnAuthorizedRoute>(
      path: '/unAuthorized', name: 'unAuthorized', routes: []);

  static const authRoute =
      TypedGoRoute<AuthRoute>(path: '/auth', name: 'auth', routes: []);
}
