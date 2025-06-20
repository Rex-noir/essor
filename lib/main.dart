import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile/app.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kDebugMode) {
    WakelockPlus.enable();
  }
  // final isFirstTime = true;
  runApp(App());
}
