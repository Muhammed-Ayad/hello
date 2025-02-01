import 'package:json_annotation/json_annotation.dart';

part "notification.g.dart";

@JsonSerializable()
class NotficationData {
  bool isAzkarActive;
  bool isPrayerTimesActive;

  NotficationData(
      {required this.isAzkarActive, required this.isPrayerTimesActive});

  factory NotficationData.fromJson(Map<String, dynamic> json) =>
      _$NotficationDataFromJson(json);

  Map<String, dynamic> toJson() => _$NotficationDataToJson(this);
}
