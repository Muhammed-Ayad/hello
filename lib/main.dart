import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:great_quran/helpers/cache_helper.dart';
import 'package:great_quran/helpers/locales.dart';
import 'package:great_quran/ui/app.dart';
import 'package:flutter/material.dart';
import 'package:great_quran/blocs/models/azan/azan.dart';
import 'package:great_quran/data/remote/client/remote_client.dart';
import 'package:great_quran/services/location_service.dart';
import 'package:great_quran/data/remote/endpoints.dart';

import 'data/remote/apis/azan_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();
  await CacheHelper.init();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.grey,
    ),
  );
  runApp(
    EasyLocalization(
      path: 'assets/translations',
      supportedLocales: const [
        AppLocales.arabic,
      ],
      child: ProviderScope(child: MyApp()),
    ),
  );
}
