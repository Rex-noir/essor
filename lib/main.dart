import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile/app.dart';
import 'package:mobile/config/dev_config.dart';
import 'package:mobile/domain/enums/authentication_status.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final appConfig = DevConfig();

  if (kDebugMode) {
    WakelockPlus.enable();
  }

  final initialStatus = prefs.getString(appConfig.accessTokenKey) != null
      ? AuthenticationStatus.authenticated
      : AuthenticationStatus.unauthenticated;

  final isFirstTime = prefs.getBool(appConfig.isFirstTimeKey) ?? true;
  if (isFirstTime) {
    prefs.setBool(appConfig.isFirstTimeKey, false);
  }

  // final isFirstTime = true;
  runApp(
    App(
      initialStatus: initialStatus,
      appConfig: appConfig,
      isFirstTime: isFirstTime,
    ),
  );
}
