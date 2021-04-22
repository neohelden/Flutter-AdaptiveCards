import 'package:flutter/material.dart';

import '../../brightness_switch.dart';
import '../../loading_adaptive_card.dart';

/// Demonstrates the AdaptiveNumberInput.
class InputNumber extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Input.Number"),
        actions: [
          BrightnessSwitch(),
        ],
      ),
      body: ListView(
        children: <Widget>[
          DemoAdaptiveCard("lib/inputs/input_number/example1"),
        ],
      ),
    );
  }
}
