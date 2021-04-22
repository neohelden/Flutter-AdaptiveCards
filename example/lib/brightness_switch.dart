import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Allows toggling between light and dark theme.
class BrightnessSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Switch(
      value: Theme.of(context).brightness == Brightness.light,
      activeTrackColor: Colors.white,
      activeColor: Colors.grey,
      inactiveTrackColor: Colors.white,
      onChanged: (changeToLight) {
        var mode =
            changeToLight ? AdaptiveThemeMode.light : AdaptiveThemeMode.dark;
        AdaptiveTheme.of(context).setThemeMode(mode);
      },
    );
  }
}
