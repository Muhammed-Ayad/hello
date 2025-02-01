import 'package:flutter/material.dart';
import 'package:great_quran/data/remote/endpoints.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

/// A collection of simple algorithms to reduce code boilerplate.
mixin Utilities {
  static String dateTimeNow() =>
      DateFormat('yyyy-MM-dd').format(DateTime.now());

  static Future<void> sendMessage() async {
    final Uri url = Uri.parse(AppEndpoints.mailTo);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw "Error $url";
    }
  }

  static DateTime convertToDateTime(String time) {
    final now = DateTime.now();
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return DateTime(now.year, now.month, now.day, hour, minute);
  }
}
