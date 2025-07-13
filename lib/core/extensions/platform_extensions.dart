import 'dart:io';

class PlatformExtensions {
  static bool get isMobile => Platform.isAndroid || Platform.isIOS;
}
