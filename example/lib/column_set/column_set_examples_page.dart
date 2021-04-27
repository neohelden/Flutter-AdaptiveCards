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
          DemoAdaptiveCard("lib/column_set/example1"),
          DemoAdaptiveCard("lib/column_set/example2"),
          DemoAdaptiveCard("lib/column_set/example3"),
          DemoAdaptiveCard("lib/column_set/example4"),
          DemoAdaptiveCard("lib/column_set/example5", supportMarkdown: false),
          DemoAdaptiveCard("lib/column_set/example6", supportMarkdown: false),
          DemoAdaptiveCard("lib/column_set/example7"),
          DemoAdaptiveCard("lib/column_set/example8"),
          DemoAdaptiveCard("lib/column_set/example9"),
          DemoAdaptiveCard("lib/column_set/example10"),
          DemoAdaptiveCard("lib/column_set/column_width_in_pixels",
              supportMarkdown: false),
        ],
      ),
    );
  }
}
