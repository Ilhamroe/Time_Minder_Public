import 'package:flutter/material.dart';
import 'package:time_minder/pages/onBoarding_page.dart';
import 'package:time_minder/pages/timer_page.dart';
import 'package:time_minder/pages/view_timer_recommedation_page.dart';
import 'package:time_minder/widgets/common/bottom_navbar.dart';
import 'package:time_minder/widgets/onboarding_page/splash_screen.dart';

class AppRoutes {
  static const String splash = "/";
  static const String onboard = "/onboard";
  static const String navbar = "/navbar";
  static const String home = "/home";
  static const String listTimer = "/list_timer";
  static const String timerViewRecommendation = "/timer_view_recommendation";
  static const String timerViewList = "/timer_view_list";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const SplashScreen(),
        );

      case AppRoutes.onboard:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const OnboardingPage(),
        );

      case AppRoutes.navbar:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const NavbarBottom(),
        );

      case AppRoutes.listTimer:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const TimerPage(),
        );

      case AppRoutes.timerViewRecommendation:
        final int? index = settings.arguments as int?;
        if (index != null) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => TimerView(timerIndex: index),
          );
        }
        return _errorRoute(settings);

      default:
        return _errorRoute(settings);
    }
  }

  static MaterialPageRoute _errorRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(
          child: Text('No route defined for ${settings.name}'),
        ),
      ),
    );
  }
}
