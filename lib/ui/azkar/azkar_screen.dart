import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:great_quran/blocs/notifiers/notifications_subscription_notifier.dart';
import 'package:great_quran/blocs/state_mix/state_mix.dart';
import 'package:great_quran/data/local/json/all_azkar.dart';
import 'package:great_quran/generated/locale_keys.g.dart';
import 'package:great_quran/helpers/extensions.dart';
import 'package:great_quran/helpers/ui_helpers.dart';
import 'package:great_quran/theme/dimensions.dart';
import 'package:great_quran/ui/animations/bottom_animation.dart';
import 'package:great_quran/resources/assets_manager.dart';
import 'package:great_quran/ui/widgets/custom_app_bar.dart';
import 'package:great_quran/ui/widgets/loading_widget.dart';
import 'azkar_category_screen.dart';

class AzkarScreen extends ConsumerStatefulWidget {
  const AzkarScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AzkarScreen> createState() => _AzkarScreenState();
}

class _AzkarScreenState extends ConsumerState<AzkarScreen> {
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
        title: LocaleKeys.title_azkar.tr(),
        actions: [
          Consumer(builder: (context, ref, _) {
            final state = ref.watch(NotificationsSubscriptionNotifier.provider);
            final notifier =
                ref.read(NotificationsSubscriptionNotifier.provider.notifier);
            return state.when(
              data: (isActive) {
                return IconButton(onPressed: () async {
                  await notifier.toggleAzkar();
                }, icon: Consumer(builder: (context, ref, _) {
                  return Icon(
                    isActive.isAzkarActive
                        ? Icons.notifications
                        : Icons.notification_add,
                    color: isActive.isAzkarActive ? Colors.amberAccent : null,
                  );
                }));
              },
              loading: () => const Padding(
                padding: EdgeInsets.all(D.sizeSmall),
                child: LoadingWidget(
                  size: D.size3XLarge,
                ),
              ),
              error: (e) => IconButton(
                  onPressed: () async {
                    "Refresh the notification subscription fetching".log();
                    await ref
                        .read(
                            NotificationsSubscriptionNotifier.provider.notifier)
                        .fetchData();
                  },
                  icon: Icon(
                    Icons.refresh,
                    size: D.size3XLarge,
                    color: context.colorScheme.error,
                  )),
            );
          })
        ],
      ),
      body: ListView.builder(
        itemCount: azkarDataList.length,
        itemBuilder: (BuildContext context, int index) {
          return WidgetAnimator(
            child: _ItemWidget(index),
          );
        },
      ),
    );
  }
}

class _ItemWidget extends StatelessWidget {
  final int index;
  const _ItemWidget(this.index);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.heightR(0.12),
      margin: const EdgeInsets.symmetric(horizontal: D.sizeSmall),
      decoration: BoxDecoration(
        color: context.colorScheme.shadow,
        borderRadius: BorderRadius.circular(D.sizeSmall),
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(D.sizeSmall),
        ),
        elevation: D.sizeXSmall,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AzkarCategoryScreen(
                  azkar: azkarDataList[index].toString().trim(),
                ),
              ),
            );
          },
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(D.sizeSmall),
                child: Image(
                  fit: BoxFit.fill,
                  image: AssetImage(
                    ImageAssets.star,
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: D.sizeXSmall),
                  child: Text(
                    azkarDataList[index].toString(),
                    style: context.textTheme.headlineLarge,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
