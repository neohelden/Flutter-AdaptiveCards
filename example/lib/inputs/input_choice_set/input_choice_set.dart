import 'package:flutter/material.dart';

import '../../brightness_switch.dart';
import '../../loading_adaptive_card.dart';

/// Demonstrates the AdaptiveChoiceSet.
class InputChoiceSetPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Input.ChoiceSet"),
        actions: [
          BrightnessSwitch(),
        ],
      ),
      body: ListView(
        children: <Widget>[
          DemoAdaptiveCard("lib/inputs/input_choice_set/example1"),
        ],
      ),
    );
  }
}
