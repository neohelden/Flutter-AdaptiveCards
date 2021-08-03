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
          DemoAdaptiveCard("lib/container/default.json"),
          DemoAdaptiveCard("lib/container/style_and_action.json"),
          DemoAdaptiveCard("lib/container/style_on_top_of_ac_style.json"),
          DemoAdaptiveCard("lib/container/verticalContentAlignment.json"),
          DemoAdaptiveCard("lib/container/separator_and_spacing.json"),
        ],
      ),
    );
  }
}
