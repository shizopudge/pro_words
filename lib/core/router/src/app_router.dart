import 'package:auto_route/auto_route.dart';
import 'package:pro_words/core/router/router.dart';

export 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends $AppRouter {
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
