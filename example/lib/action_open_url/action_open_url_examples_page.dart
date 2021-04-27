import 'package:flutter/material.dart';

import '../brightness_switch.dart';
import '../loading_adaptive_card.dart';

/// Demonstrates the open url action.
class ActionOpenUrlPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Action.OpenUrl"),
        actions: [
          BrightnessSwitch(),
        ],
      ),
      body: ListView(
        children: <Widget>[
          DemoAdaptiveCard("lib/action_open_url/example1"),
          DemoAdaptiveCard("lib/action_open_url/example2"),
        ],
      ),
    );
  }
}
