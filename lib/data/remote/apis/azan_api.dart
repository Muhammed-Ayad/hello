import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:great_quran/blocs/models/azan/azan.dart';
import 'package:great_quran/blocs/state_mix/state_mix.dart';
import 'package:great_quran/data/remote/client/remote_client.dart';
import 'package:great_quran/data/remote/endpoints.dart';
import 'package:great_quran/data/remote/interfaces/i_azan_time_api.dart';
import 'package:great_quran/services/location_service.dart';
import 'package:location/location.dart';

class AzanTimeApi implements IAzanTimeApi {
  // Dependencies
  final RemoteClient _remoteClient;
  final LocationService _locationService;

  // Provider
  static final provider = Provider<IAzanTimeApi>(
    (ref) => AzanTimeApi(
      ref.read(RemoteClient.provider),
      ref.read(LocationService.provider),
    ),
  );

  AzanTimeApi(this._remoteClient, this._locationService);

  /// Single-shot fetch

  Future<Azan> getAzan() async {
    final locationData = await _locationService.getCurrentLocation();
    if (locationData != null &&
        locationData.latitude != null &&
        locationData.longitude != null) {
      final response = await _remoteClient.get(
        AppEndpoints.azanApiByCoordinates(
          locationData.latitude!,
          locationData.longitude!,
        ),
      );
      return Azan.fromJson(response);
    } else {
      throw "تأكد من تشغيل خدمة الموقع و إعطاء الإذن للتطبيق";
    }
  }

  @override
  Stream<Azan> getAzanStream() async* {
    try {
      final azanData = await getAzan();
      yield azanData;
    } catch (e) {
      rethrow;
    }
  }
}
