import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:great_quran/data/remote/endpoints.dart';
import 'package:great_quran/generated/locale_keys.g.dart';
import 'package:great_quran/helpers/extensions.dart';
import 'package:great_quran/theme/dimensions.dart';
import 'package:great_quran/resources/routes_manager.dart';
import 'package:great_quran/ui/widgets/card_button_widget.dart';

import 'package:share_plus/share_plus.dart';
import 'package:in_app_review/in_app_review.dart';

class DrawerPage extends StatelessWidget {
  const DrawerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final InAppReview inAppReview = InAppReview.instance;

    return SafeArea(
      child: Drawer(
        child: ListView(
          children: [
            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: D.sizeSmall,
                vertical: D.sizeLarge,
              ),
              title: Align(
                alignment: Alignment.center,
                child: Text(
                  LocaleKeys.title_app_bar.tr(),
                  style: context.textTheme.displayLarge,
                ),
              ),
            ),
            Divider(
              color: context.colorScheme.primary,
            ),
            CardButtonWidget(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  Routes.settingsRoute,
                );
              },
              title: LocaleKeys.title_settings.tr(),
              icon: Icons.settings,
            ),
            CardButtonWidget(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  Routes.contantUsRoute,
                );
              },
              title: LocaleKeys.title_contant_us.tr(),
              icon: Icons.contact_support,
            ),
            CardButtonWidget(
              onTap: () {
                Share.share(AppEndpoints.linkPlayGoogle);
              },
              title: LocaleKeys.title_share.tr(),
              icon: Icons.share,
            ),
            CardButtonWidget(
              onTap: () async {
                if (await inAppReview.isAvailable()) {
                  inAppReview.requestReview();
                }
                inAppReview.openStoreListing();
              },
              title: LocaleKeys.title_review.tr(),
              icon: Icons.reviews,
            ),
          ],
        ),
      ),
    );
  }
}
