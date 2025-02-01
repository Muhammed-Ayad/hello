import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:great_quran/blocs/models/azan/azan.dart';
import 'package:great_quran/blocs/state_mix/state_mix.dart';
import 'package:great_quran/data/remote/apis/azan_api.dart';
import 'package:great_quran/data/remote/interfaces/i_azan_time_api.dart';

class AzanTimeNotifier extends StateNotifier<GenericState<Azan>> {
  static final provider =
      StateNotifierProvider<AzanTimeNotifier, GenericState<Azan>>((ref) {
    return AzanTimeNotifier(ref.read(AzanTimeApi.provider));
  });

  final IAzanTimeApi _azanTimeApi;

  /// Keep a reference to our subscription so we can cancel/restart it.
  StreamSubscription<Azan>? _azanSubscription;

  AzanTimeNotifier(this._azanTimeApi) : super(GenericState.initial()) {
    // Start listening immediately
    _subscribeToAzan();
  }

  /// Helper method to subscribe to the Azan stream
  void _subscribeToAzan() {
    // Mark as loading while waiting for the first data emission.
    state = GenericState.loading();

    _azanSubscription?.cancel();
    _azanSubscription = _azanTimeApi.getAzanStream().listen(
      (azanData) {
        // Each time we get a new azan, emit success
        state = GenericState.success(azanData);
      },
      onError: (error, stack) {
        debugPrint('AzanTimeNotifier Stream Error: $error');
        // Mark as failure; optionally store the error message
        state = GenericState.fail();
      },
    );
  }

  /// Public method to force a re-subscription. E.g., a “retry” button can call this.
  void restartStream() {
    _subscribeToAzan();
  }

  @override
  void dispose() {
    _azanSubscription?.cancel();
    super.dispose();
  }
}
