import 'package:flutter/material.dart';
import 'package:great_quran/theme/colors.dart';
import 'package:great_quran/ui/settings/settings_screen.dart';
import '../main.dart';
import '../ui/qibla/qibla_screen.dart';
import '../ui/nawawi/nawawi_screen.dart';
import '../ui/radios/radio_categories_screen.dart';
import '../ui/azan/azan_screen.dart';
import '../ui/azkar/azkar_screen.dart';
import '../ui/contant_us/contant_us_view.dart';
import '../ui/main_view.dart';

class Routes {
  static const String mainRoute = "/";
  static const String azanRoute = "/azan";
  static const String azkarRoute = "/azkarView";
  static const String contantUsRoute = "/contactUs";
  static const String qiblaRoute = "/qibla";
  static const String nawawiRoute = "/nawawi";
  static const String radiosRoute = "/radios";
  static const String settingsRoute = "/settingsRoute";
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // final args = settings.arguments;

    switch (settings.name) {
      case Routes.settingsRoute:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case Routes.mainRoute:
        return MaterialPageRoute(builder: (_) => const MainView());
      case Routes.azanRoute:
        return MaterialPageRoute(builder: (_) => const AzanScreen());
      case Routes.contantUsRoute:
        return MaterialPageRoute(builder: (_) => const ContantUsView());
      case Routes.azkarRoute:
        return MaterialPageRoute(builder: (_) => const AzkarScreen());
      case Routes.qiblaRoute:
        return MaterialPageRoute(builder: (_) => const QiblaScreen());
      case Routes.nawawiRoute:
        return MaterialPageRoute(builder: (_) => const NawawiScreen());

      case Routes.radiosRoute:
        return MaterialPageRoute(builder: (_) => const RadioCategoriesScreen());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        backgroundColor: AppColors.primary,
      );
    });
  }
}
