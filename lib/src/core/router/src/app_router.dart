import 'package:auto_route/auto_route.dart';
import 'package:pro_words/src/core/router/src/app_router.dart';

export 'app_router.gr.dart';

/// {@template app_router}
/// Роутер
/// {@endtemplate}
@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends $AppRouter {
  /// {@macro app_router}
  AppRouter();

  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  @override
  late final List<AutoRoute> routes = [
    AdaptiveRoute(
      page: HomeRoute.page,
      path: '/',
      initial: true,
    ),
  ];
}
