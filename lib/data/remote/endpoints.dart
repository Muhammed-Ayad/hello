mixin AppEndpoints {
  static const _baseUrl = 'assets/json';

  static const quranApi = '$_baseUrl/quran.json';
  static const radiosApi = '$_baseUrl/radios_new.json';
  static const nawawiApi = '$_baseUrl/nawawi.json';
  static String azanApi =
      'https://api.aladhan.com/v1/timingsByCity?city=cairo&country=Egypt';

// modified
  static String azanApiByCoordinates(double latitude, double longitude) =>
      "https://api.aladhan.com/v1/timings?latitude=$latitude&longitude=$longitude";
  static const mailTo = "mailto:mohamedayaddev@gmail.com";

  static String qiblaApi(double latitude, double longitude) =>
      "http://api.aladhan.com/v1/qibla/$latitude/$longitude";

  static const linkPlayGoogle =
      "https://play.google.com/store/apps/details?id=com.convey.ayah.mohamed.ayad";
}
