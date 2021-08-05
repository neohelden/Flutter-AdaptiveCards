import 'package:flutter/material.dart';

import '../brightness_switch.dart';
import '../loading_adaptive_card.dart';

/// Demonstrates the AdaptiveColumnSet.
class ColumnSetPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ColumnSet"),
        actions: [
          BrightnessSwitch(),
        ],
      ),
      body: ListView(
        children: <Widget>[
          DemoAdaptiveCard("lib/column_set/default.json"),
          DemoAdaptiveCard("lib/column_set/spacing.json"),
          DemoAdaptiveCard("lib/column_set/separator.json"),
          DemoAdaptiveCard("lib/column_set/horizontalAlignment_left.json"),
          DemoAdaptiveCard("lib/column_set/horizontalAlignment_center.json"),
          DemoAdaptiveCard("lib/column_set/horizontalAlignment_right.json"),
        ],
      ),
    );
  }
}
