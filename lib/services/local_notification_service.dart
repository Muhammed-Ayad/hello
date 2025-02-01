// Copyright (c) 2023 by Salama Enigma (salama92work@gmail.com)
// All rights reserved.
// Check out my Github account (https://github.com/salamaEnigma) for more projects.

import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:great_quran/blocs/state_mix/state_mix.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart' as tz;

/// Service that handle local notifications for android and iOS
/// it wraps the functionality of the flutter_local_notifications package.
/// it provides a set of methods to handle the creation, scheduling, and removal of notifications.
class LocalNotificationService {
  static final provider = Provider<LocalNotificationService>((ref) {
    return LocalNotificationService();
  });

  // Dependencies
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// A flag to indicate wether the initialization process was a success
  bool get isInitSuccess => _isInitSuccess;
  bool _isInitSuccess = false;

  /// Creates platform specific notification details for each platform
  final NotificationDetails _platformChannelSpecificsNotificationDetails =
      const NotificationDetails(
          android: AndroidNotificationDetails("Enigma", "Local Notification"),
          iOS: DarwinNotificationDetails());

  /// Initialize the Service
  /// it uses FlutterNativeTimezone package to get the current time zone in order to use it
  /// in notifications scheduling then Initialize the  FlutterLocalNotificationsPlugin plugin with
  /// Android and iOS settings
  /// if the initialization is success returns true otherwise returns false
  Future<bool> init() async {
    log('Init notification service');

    try {
      // Initialize Time Zones
      initializeTimeZones();

      // Get device time zone
      final currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
      currentTimeZone.log();
      log('Current Time Zone: $currentTimeZone');

      // Set location with currentTimeZone
      tz.setLocalLocation(tz.getLocation(currentTimeZone));

      // Creating plugin settings for (Android - iOS ).

      // Android settings
      // note: app_icon needs to be a added as a drawable resource to the Android head project
      // initialize the plugin. app_icon needs to be a added as a drawable resource to the Android head project
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('app_icon');

      // iOS settings
      const DarwinInitializationSettings initializationSettingsDarwin =
          DarwinInitializationSettings();

      const InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin,
      );

      // Initialize the plugin
      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (details) {
          "Notification is pressed".log();
          details.payload.log();
          print(
            DateTime.now().toString(),
          );
        },
      );

      return _isInitSuccess = true;
    } catch (e, s) {
      "Local notification service initialization failed due to:\n$e\n$s";
      return _isInitSuccess = false;
    }
  }

  /// Schedules a notification to show on the given time
  Future<void> schedule(
      {required int id,
      required ScheduleReminder scheduleReminder,
      required DateTime dateTime,
      required String title,
      required String body,
      String? payload}) async {
    "Schedule notification on  on a $scheduleReminder".log();

    await Future.delayed(const Duration(milliseconds: 50));
    flutterLocalNotificationsPlugin.zonedSchedule(
      id, // use it as an id
      title,
      body,
      tz.TZDateTime(
        tz.local,
        dateTime.year,
        dateTime.month,
        dateTime.day,
        dateTime.hour,
        dateTime.minute, // Include minute & second if needed
        dateTime.second,
      ),
      _platformChannelSpecificsNotificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: scheduleReminder.dateTimeComponents,
      payload: payload,
    );

    tz.TZDateTime(
      tz.local,
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      dateTime.minute, // Include minute & second if needed
      dateTime.second,
    ).log();
  }

  /// Cancels all  notifications
  Future<void> cancel(List<int> notificationIds) async {
    notificationIds.forEach((element) {
      flutterLocalNotificationsPlugin.cancel(element);
    });
  }

  /// Check If the app has pending (scheduled) notifications
  Future<bool> checkPendingNotifications() async {
    final pendingRequests =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    "Has Pending Notifications ? ${pendingRequests.isNotEmpty}".log();
    return pendingRequests.isNotEmpty;
  }
}

enum ScheduleReminder {
  monthly,
  weekly,
  daily;

  DateTimeComponents get dateTimeComponents {
    switch (this) {
      case ScheduleReminder.monthly:
        return DateTimeComponents.dayOfMonthAndTime;
      case ScheduleReminder.weekly:
        return DateTimeComponents.dayOfWeekAndTime;
      case ScheduleReminder.daily:
        return DateTimeComponents.time;
    }
  }
}
