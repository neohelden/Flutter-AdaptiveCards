import 'package:flutter/material.dart';

import '../brightness_switch.dart';
import '../loading_adaptive_card.dart';

/// Demonstrates the AdaptiveContainer.
class ContainerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Container"),
        actions: [
          BrightnessSwitch(),
        ],
      ),
      body: ListView(
        children: <Widget>[
          DemoAdaptiveCard("lib/container/example1.json"),
          DemoAdaptiveCard("lib/container/example2.json"),
          DemoAdaptiveCard("lib/container/example3.json"),
          DemoAdaptiveCard("lib/container/example4.json"),
          DemoAdaptiveCard("lib/container/example5.json"),
        ],
      ),
    );
  }
}
