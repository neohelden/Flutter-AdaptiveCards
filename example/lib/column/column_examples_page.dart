import 'package:flutter/material.dart';

import '../brightness_switch.dart';
import '../loading_adaptive_card.dart';

/// Demonstrates the AdaptiveColumn.
class ColumnPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Column"),
        actions: [
          BrightnessSwitch(),
        ],
      ),
      body: ListView(
        children: <Widget>[
          DemoAdaptiveCard("lib/column/example1.json"),
          DemoAdaptiveCard("lib/column/example2.json"),
          DemoAdaptiveCard("lib/column/example3.json"),
          DemoAdaptiveCard("lib/column/example4.json"),
          DemoAdaptiveCard("lib/column/example5.json"),
        ],
      ),
    );
  }
}
