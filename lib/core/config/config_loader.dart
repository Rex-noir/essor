import 'package:mobile/core/config/app_config.dart';
import 'package:mobile/core/config/dev_config.dart';

class ConfigLoader {
  static AppConfig load() {
    const env = String.fromEnvironment("ENV", defaultValue: "dev");

    switch (env) {
      case 'dev':
      default:
        return DevConfig();
    }
  }
}
