import 'package:great_quran/blocs/models/azan/azan.dart';

abstract class IAzanTimeApi {
  /// Single‐shot fetch of the current Azan times

  /// Ongoing stream of Azan times (e.g., emits every minute)
  Stream<Azan> getAzanStream();
}
