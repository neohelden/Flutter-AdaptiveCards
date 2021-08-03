import 'package:flutter/material.dart';

import '../../brightness_switch.dart';
import '../../loading_adaptive_card.dart';

/// Demonstrates the date input field.
class InputDatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Input.Date"),
        actions: [
          BrightnessSwitch(),
        ],
      ),
      body: ListView(
        children: <Widget>[
          DemoAdaptiveCard("lib/inputs/input_date/placeholder_and_value.json"),
        ],
      ),
    );
  }
}
