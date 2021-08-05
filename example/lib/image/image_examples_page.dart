import 'package:flutter/material.dart';

import '../brightness_switch.dart';
import '../loading_adaptive_card.dart';

/// Demonstrates the AdaptiveCardImage.
class ImagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image"),
        actions: [
          BrightnessSwitch(),
        ],
      ),
      body: ListView(
        children: <Widget>[
          DemoAdaptiveCard("lib/image/selectAction_submit.json"),
          DemoAdaptiveCard("lib/image/selectAction_openUrl.json"),
          DemoAdaptiveCard("lib/image/alignment.json"),
          DemoAdaptiveCard("lib/image/styles.json"),
          DemoAdaptiveCard("lib/image/separator.json"),
          DemoAdaptiveCard("lib/image/width_and_height_in_pixels.json"),
          DemoAdaptiveCard("lib/image/width_in_pixels.json"),
          DemoAdaptiveCard("lib/image/height_in_pixels.json"),
          DemoAdaptiveCard("lib/image/in_column_set.json"),
        ],
      ),
    );
  }
}
