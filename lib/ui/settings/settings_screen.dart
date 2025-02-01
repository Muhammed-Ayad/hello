import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:great_quran/helpers/cache_helper.dart';
import 'package:great_quran/helpers/extensions.dart';
import 'package:great_quran/helpers/ui_helpers.dart';
import 'package:great_quran/theme/dimensions.dart';

import '../../blocs/notifiers/notifications_subscription_notifier.dart';
import '../../generated/locale_keys.g.dart';
import '../widgets/custom_app_bar.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    UiHelper.postBuild((_) async {
      await ref
          .read(NotificationsSubscriptionNotifier.provider.notifier)
          .fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: LocaleKeys.title_settings.tr(),
        ),
        body: Consumer(
          builder: (context, ref, __) {
            final state = ref.watch(NotificationsSubscriptionNotifier.provider);
            final notifier =
                ref.read(NotificationsSubscriptionNotifier.provider.notifier);
            return state.whenOrNull(data: (notificationData) {
                  return Column(
                    children: [
                      SwitchTile(
                          value: notificationData.isPrayerTimesActive,
                          title: LocaleKeys.prayer_times_notifications.tr(),
                          onChanged: (value) async {
                            await notifier.togglePrayerTimes();
                          }),
                      SwitchTile(
                          value: notificationData.isAzkarActive,
                          title: LocaleKeys.azkar_notifications.tr(),
                          onChanged: (value) {
                            notifier.toggleAzkar();
                          })
                    ],
                  );
                }) ??
                SizedBox();
          },
        ));
  }
}

class SwitchTile extends StatefulWidget {
  SwitchTile(
      {super.key,
      required this.title,
      required this.onChanged,
      required this.value});
  final String title;
  final Function(bool value) onChanged;
  bool value = false;
  @override
  State<SwitchTile> createState() => _SwitchTileState();
}

class _SwitchTileState extends State<SwitchTile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: D.sizeLarge, right: D.sizeLarge, top: D.sizeXLarge),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          widget.title,
          style: context.textTheme.headlineLarge,
        ),
        Switch(
          activeColor: context.colorScheme.primary,
          value: widget.value,
          onChanged: (value) {
            setState(() {
              widget.value = value;
              CacheHelper.setActivePrayerTimesNotifications(value);
            });
            widget.onChanged(value);
          },
        ),
      ]),
    );
  }
}
