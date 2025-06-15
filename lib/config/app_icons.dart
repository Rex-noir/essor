import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppIcons {
  static IconData getIcon(int index) {
    if (index >= 0 && index < icons.length) {
      return icons[index];
    }
    return Icons.help_outline;
  }

  static int getIconIndex(IconData iconData) {
    return icons.indexOf(iconData);
  }

  static Map<String, List<IconData>> categorizedIcons = {
    "General": [
      CupertinoIcons.checkmark_seal_fill,
      FontAwesomeIcons.repeat,
      Icons.self_improvement,
    ],
    "3D & Time": [
      Icons.threesixty,
      Icons.threed_rotation,
      Icons.four_k,
      Icons.access_time,
    ],
    "Nature": [Icons.ac_unit],
    "Alarms": [Icons.access_alarm, Icons.access_alarms],
    "Accessibility": [Icons.accessibility],
  };

  static List<IconData> get icons =>
      categorizedIcons.values.expand((e) => e).toList();
}
