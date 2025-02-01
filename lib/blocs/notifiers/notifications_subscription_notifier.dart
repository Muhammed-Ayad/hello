import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:great_quran/blocs/models/notification/notification.dart';
import 'package:great_quran/data/remote/apis/azan_api.dart';
import 'package:great_quran/data/remote/interfaces/i_azan_time_api.dart';
import 'package:great_quran/generated/locale_keys.g.dart';
import 'package:great_quran/helpers/cache_helper.dart';
import 'package:great_quran/helpers/utilities.dart';
import 'package:great_quran/services/local_notification_service.dart';
import '../../data/local/json/all_azkar.dart';
import '../../ui/azan/azan_screen.dart';
import '../../ui/azkar/azkar_category_screen.dart';
import '../models/azan/azan.dart';
import '../state_mix/state_mix.dart';

class NotificationsSubscriptionNotifier
    extends StateNotifier<GenericState<NotficationData>>
    with DataFetcherForStateNotifier {
  static final provider = StateNotifierProvider<
      NotificationsSubscriptionNotifier, GenericState<NotficationData>>((ref) {
    return NotificationsSubscriptionNotifier(
      ref.read(LocalNotificationService.provider),
      ref.read(AzanTimeApi.provider),
    );
  });

  final LocalNotificationService _service;
  final IAzanTimeApi _azanTimeApi;
  late final StreamSubscription<Azan> _azanSubscription;
  Azan? _latestAzan;
  NotificationsSubscriptionNotifier(this._service, this._azanTimeApi)
      : super(GenericState.initial()) {
    _azanSubscription = _azanTimeApi.getAzanStream().listen(
      (azan) {
        _latestAzan = azan;
      },
      onError: (error, stack) {
        debugPrint('Azan stream error: $error');
        state = GenericState.fail();
      },
    );
  }

  @override
  AsyncFetchFunction<NotficationData> get dataFetcher =>
      () async => NotficationData(
          isAzkarActive: CacheHelper.getActiveAzkarNotifications(),
          isPrayerTimesActive: CacheHelper.getActivePrayerTimesNotifications());

  /// Toggles notifications for Azkar and Prayer Times
  Future<void> toggleAzkar() async {
    if (state.isSuccess) {
      if (state.getData()!.isAzkarActive) {
        // Cancel all notifications
        await _service.cancel([0, 1]);
        Fluttertoast.showToast(
          msg: LocaleKeys.azkar_notifications_off.tr(),
          backgroundColor: Colors.red,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT,
        );
        CacheHelper.setActiveAzkarNotifications(false);
      } else {
        // Register notifications
        await registerAzkarNotifications();

        Fluttertoast.showToast(
          msg: LocaleKeys.azkar_notifications_on.tr(),
          backgroundColor: Colors.green,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT,
        );
        CacheHelper.setActiveAzkarNotifications(true);
      }
      state.getData()!.isAzkarActive = !state.getData()!.isAzkarActive;
      state = GenericState.success(state.getData()!);
    }
  }

  Future<void> togglePrayerTimes({int earlyOffset = 10}) async {
    if (state.isSuccess) {
      if (state.getData()!.isPrayerTimesActive) {
        // Cancel all notifications
        await _service.cancel(
          [2, 3, 4, 5, 6],
        );
        Fluttertoast.showToast(
          msg: LocaleKeys.prayer_times_notifications_off.tr(),
          backgroundColor: Colors.red,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT,
        );
        CacheHelper.setActivePrayerTimesNotifications(false);
      } else {
        // Register notifications

        await registerPrayerNotifications(earlyOffset);
        Fluttertoast.showToast(
          msg: LocaleKeys.prayer_times_notifications_on.tr(),
          backgroundColor: Colors.green,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT,
        );
        CacheHelper.setActivePrayerTimesNotifications(true);
      }
      state.getData()!.isPrayerTimesActive =
          !state.getData()!.isPrayerTimesActive;
      state = GenericState.success(state.getData()!);
    }
  }

  /// Registers scheduled notifications for Azkar

  Future<void> registerAzkarNotifications() async {
    final now = DateTime.now();

    await _service.schedule(
      id: 0,
      scheduleReminder: ScheduleReminder.daily,
      dateTime: DateTime(now.year, now.month, now.day, 7, 0),
      title: "بلغوا",
      body: "نذكرك بقراءة أذكار الصباح",
      payload: "0",
    );

    await _service.schedule(
      id: 1,
      scheduleReminder: ScheduleReminder.daily,
      dateTime: DateTime(now.year, now.month, now.day, 17, 0),
      title: "بلغوا",
      body: "نذكرك بقراءة أذكار المساء",
      payload: "1",
    );
  }

  /// Registers scheduled notifications for Prayer Times
  Future<void> registerPrayerNotifications(int earlyOffset) async {
    if (_latestAzan == null) {
      // If we haven't received Azan data yet, handle accordingly
      return;
    }

    final prayerTimes = [
      _latestAzan!.data.timings.fajr,
      _latestAzan!.data.timings.dhuhr,
      _latestAzan!.data.timings.asr,
      _latestAzan!.data.timings.maghrib,
      _latestAzan!.data.timings.isha,
    ].map((time) => Utilities.convertToDateTime(time)).toList();

    await _service.schedule(
      id: 2,
      scheduleReminder: ScheduleReminder.daily,
      dateTime: prayerTimes[0].subtract(Duration(minutes: earlyOffset)),
      title: "تذكير بوقت الصلاة",
      body: "حان وقت صلاة الفجر، استعد للصلاة.",
      payload: "fajr",
    );

    await _service.schedule(
      id: 3,
      scheduleReminder: ScheduleReminder.daily,
      dateTime: prayerTimes[1].subtract(Duration(minutes: earlyOffset)),
      title: "تذكير بوقت الصلاة",
      body: "حان وقت صلاة الظهر، استعد للصلاة.",
      payload: "dhuhr",
    );

    await _service.schedule(
      id: 4,
      scheduleReminder: ScheduleReminder.daily,
      dateTime: prayerTimes[2].subtract(Duration(minutes: earlyOffset)),
      title: "تذكير بوقت الصلاة",
      body: "حان وقت صلاة العصر، استعد للصلاة.",
      payload: "asr",
    );

    await _service.schedule(
      id: 5,
      scheduleReminder: ScheduleReminder.daily,
      dateTime: prayerTimes[3].subtract(Duration(minutes: earlyOffset)),
      title: "تذكير بوقت الصلاة",
      body: "حان وقت صلاة المغرب، استعد للصلاة.",
      payload: "maghrib",
    );

    await _service.schedule(
      id: 6,
      scheduleReminder: ScheduleReminder.daily,
      dateTime: prayerTimes[4].subtract(Duration(minutes: earlyOffset)),
      title: "تذكير بوقت الصلاة",
      body: "حان وقت صلاة العشاء، استعد للصلاة.",
      payload: "isha",
    );
  }

  /// Handles navigation on notification launch
  Future<void> navigateOnNotificationLaunch(
      Function(PageRoute) navigateOnLaunch) async {
    final notificationAtLaunch = await _service.flutterLocalNotificationsPlugin
        .getNotificationAppLaunchDetails();
    final didLaunchApp =
        notificationAtLaunch?.didNotificationLaunchApp ?? false;
    final payload = notificationAtLaunch?.notificationResponse?.payload;

    if (didLaunchApp && payload != null) {
      if (payload == "0" || payload == "1") {
        // Azkar notification
        navigateOnLaunch(
          MaterialPageRoute(
            builder: (context) => AzkarCategoryScreen(
              azkar:
                  azkarDataList[int.tryParse(payload) ?? 0].toString().trim(),
            ),
          ),
        );
      } else {
        // Prayer notification
        navigateOnLaunch(
          MaterialPageRoute(
            builder: (context) => const AzanScreen(),
          ),
        );
      }
    }
  }
}
