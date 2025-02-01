// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:great_quran/data/remote/apis/azan_api.dart';
// import 'package:great_quran/data/remote/interfaces/i_azan_time_api.dart';
// import 'package:great_quran/helpers/utilities.dart';
// import 'package:great_quran/services/local_notification_service.dart';
// import '../../data/local/json/all_azkar.dart';
// import '../../ui/azan/azan_screen.dart';
// import '../../ui/azkar/azkar_category_screen.dart';
// import '../models/azan/azan.dart';
// import '../state_mix/state_mix.dart';

// class NoftificationsPrayerTimesNotifier
//     extends StateNotifier<GenericState<dynamic>> with DataFetcherForStateNotifier {
//   static final provider = StateNotifierProvider<
//       NoftificationsPrayerTimesNotifier, GenericState<dynamic>>((ref) {
//     return NoftificationsPrayerTimesNotifier(
//       ref.read(LocalNotificationService.provider),
//     );
//   });

//   final LocalNotificationService _service;

//   NoftificationsPrayerTimesNotifier(
//     this._service,
//   ) : super(GenericState.initial());


//   @override
//   AsyncFetchFunction<bool> get dataFetcher =>
//       () => _service.checkPendingNotifications();

  

//   /// Toggles notifications for Azkar and Prayer Times
//   Future<void> toggle({int earlyOffset = 10}) async {
//     if (state.isSuccess) {
//       if (state.getData()!) {
//         // Cancel all notifications
//         await _service.cancelAll();
//         Fluttertoast.showToast(
//           msg: "تم إلغاء الإشعارات",
//           backgroundColor: Colors.red,
//           textColor: Colors.white,
//           toastLength: Toast.LENGTH_SHORT,
//         );
//       } else {
//         // Register notifications
//         await registerAzkarNotifications();
//         await registerPrayerNotifications(earlyOffset);
//         Fluttertoast.showToast(
//           msg: "تم الاشتراك في الإشعارات",
//           backgroundColor: Colors.green,
//           textColor: Colors.white,
//           toastLength: Toast.LENGTH_SHORT,
//         );
//       }
//       state = GenericState.success(!state.getData()!);
//     }
//   }

//   /// Registers scheduled notifications for Azkar
//   Future<void> registerAzkarNotifications() async {
//     final now = DateTime.now();

//     await _service.schedule(
//       scheduleReminder: ScheduleReminder.daily,
//       dateTime: DateTime(now.year, now.month, now.day, 7, 0),
//       title: "بلغوا",
//       body: "نذكرك بقراءة أذكار الصباح",
//       payload: "0",
//     );

//     await _service.schedule(
//       scheduleReminder: ScheduleReminder.daily,
//       dateTime: DateTime(now.year, now.month, now.day, 17, 0),
//       title: "بلغوا",
//       body: "نذكرك بقراءة أذكار المساء",
//       payload: "1",
//     );
//   }


//   Future<void> registerPrayerNotifications(int earlyOffset) async {
//     final azan = await _azanTimeApi.getAzan();

//     final prayerTimes = [
//       azan.data.timings.fajr,
//       azan.data.timings.dhuhr,
//       azan.data.timings.asr,
//       azan.data.timings.maghrib,
//       azan.data.timings.isha,
//     ].map((time) => Utilities.convertToDateTime(time)).toList();

//     await _service.schedule(
//       scheduleReminder: ScheduleReminder.daily,
//       dateTime: prayerTimes[0].subtract(Duration(minutes: earlyOffset)),
//       title: "تذكير بوقت الصلاة",
//       body: "حان وقت صلاة الفجر، استعد للصلاة.",
//       payload: "fajr",
//     );

//     await _service.schedule(
//       scheduleReminder: ScheduleReminder.daily,
//       dateTime: prayerTimes[1].subtract(Duration(minutes: earlyOffset)),
//       title: "تذكير بوقت الصلاة",
//       body: "حان وقت صلاة الظهر، استعد للصلاة.",
//       payload: "dhuhr",
//     );

//     await _service.schedule(
//       scheduleReminder: ScheduleReminder.daily,
//       dateTime: prayerTimes[2].subtract(Duration(minutes: earlyOffset)),
//       title: "تذكير بوقت الصلاة",
//       body: "حان وقت صلاة العصر، استعد للصلاة.",
//       payload: "asr",
//     );

//     await _service.schedule(
//       scheduleReminder: ScheduleReminder.daily,
//       dateTime: prayerTimes[3].subtract(Duration(minutes: earlyOffset)),
//       title: "تذكير بوقت الصلاة",
//       body: "حان وقت صلاة المغرب، استعد للصلاة.",
//       payload: "maghrib",
//     );

//     await _service.schedule(
//       scheduleReminder: ScheduleReminder.daily,
//       dateTime: prayerTimes[4].subtract(Duration(minutes: earlyOffset)),
//       title: "تذكير بوقت الصلاة",
//       body: "حان وقت صلاة العشاء، استعد للصلاة.",
//       payload: "isha",
//     );
//   }

//   /// Handles navigation on notification launch
//   Future<void> navigateOnNotificationLaunch(
//       Function(PageRoute) navigateOnLaunch) async {
//     final notificationAtLaunch = await _service.flutterLocalNotificationsPlugin
//         .getNotificationAppLaunchDetails();
//     final didLaunchApp =
//         notificationAtLaunch?.didNotificationLaunchApp ?? false;
//     final payload = notificationAtLaunch?.notificationResponse?.payload;

//     if (didLaunchApp && payload != null) {
//       if (payload == "0" || payload == "1") {
//         // Azkar notification
//         navigateOnLaunch(
//           MaterialPageRoute(
//             builder: (context) => AzkarCategoryScreen(
//               azkar:
//                   azkarDataList[int.tryParse(payload) ?? 0].toString().trim(),
//             ),
//           ),
//         );
//       }
//     }
//   }
// }
