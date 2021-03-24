import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BrightnessSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Switch(
      value: Theme.of(context).brightness == Brightness.light,
      activeTrackColor: Colors.white,
      activeColor: Colors.grey,
      inactiveTrackColor: Colors.white,
      onChanged: (value) => AdaptiveTheme.of(context).toggleThemeMode(),
    );
  }
}
