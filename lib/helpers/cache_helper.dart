import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences sharedPreferences;
  static const String _activeAzkarNotificationsKey =
      "activeAzkarNotificationsKey";
  static const String _activePrayerTimesNotificationsKey =
      "activePrayerTimesNotificationsKey";

  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static setActiveAzkarNotifications(bool value) =>
      sharedPreferences.setBool(_activeAzkarNotificationsKey, value);
  static setActivePrayerTimesNotifications(bool value) =>
      sharedPreferences.setBool(_activePrayerTimesNotificationsKey, value);

  static bool getActiveAzkarNotifications() =>
      sharedPreferences.getBool(_activeAzkarNotificationsKey) ?? false;
  static bool getActivePrayerTimesNotifications() =>
      sharedPreferences.getBool(_activePrayerTimesNotificationsKey) ?? false;
}
