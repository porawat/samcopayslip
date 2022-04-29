import 'package:flutter/widgets.dart';

class AppVersion {
  final String appName;
  final String appVersion;
  final int appNumber;
  final String appNote;
  final String appUpdate;
  final String appUrl;
  AppVersion(
      {@required this.appName,
      @required this.appVersion,
      @required this.appNumber,
      this.appNote,
      this.appUpdate,
      this.appUrl});

  factory AppVersion.fromJson(Map<String, dynamic> json) {
    return AppVersion(
      appName: json['appName'],
      appVersion: json['appVersion'],
      appNumber: json['appNumber'],
      appNote: json['appNote'],
      appUpdate: json['appUpdate'],
      appUrl: json['appUrl'],
    );
  }
}
