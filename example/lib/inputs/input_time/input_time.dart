import 'package:flutter/material.dart';

import '../../brightness_switch.dart';
import '../../loading_adaptive_card.dart';

/// Demonstrates the AdaptiveTimePicker.
class InputTimePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Input.Time"),
        actions: [
          BrightnessSwitch(),
        ],
      ),
      body: ListView(
        children: <Widget>[
          DemoAdaptiveCard("lib/inputs/input_time/min_max_and_value.json"),
          DemoAdaptiveCard("lib/inputs/input_time/min_and_max.json"),
        ],
      ),
    );
  }
}
