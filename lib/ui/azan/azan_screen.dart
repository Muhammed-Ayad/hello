import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:great_quran/blocs/providers/azan_time_provider.dart';
import 'package:great_quran/helpers/ui_helpers.dart';
import 'package:great_quran/theme/dimensions.dart';
import 'package:great_quran/resources/assets_manager.dart';
import 'package:great_quran/ui/widgets/error_widget.dart';
import 'package:great_quran/ui/widgets/loading_widget.dart';

import 'header_azan.dart';
import 'azan_item.dart';

class AzanScreen extends ConsumerWidget {
  const AzanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(AzanTimeNotifier.provider);

    return SafeArea(
      child: Scaffold(
        body: state.when(
          data: (data) {
            // We have fresh Azan data from the stream
            return Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Stack(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(D.size3XLarge),
                            bottomLeft: Radius.circular(D.size3XLarge),
                          ),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(ImageAssets.azanTwo),
                          ),
                        ),
                      ),
                      HeaderAzan(data),
                    ],
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: AzanItem(data: data),
                ),
              ],
            );
          },
          loading: () => const LoadingWidget(),
          error: (errorMsg) => CustomErrorWidget(
            errorMsg: errorMsg,
            onRefresh: () {
              // If your stream automatically retries, you might do nothing here.
              // Or, if you added a `restartStream()` method to your notifier,
              // call that instead:
              //
              ref.read(AzanTimeNotifier.provider.notifier).restartStream();
            },
          ),
        ),
      ),
    );
  }
}
